#!/bin/python3

'''
Ideas for the refactorying:

+ TODO: list of TODOs
+ DONE: list of done TODOs (ids)
'''

import json
import argparse
import sys, os, io
import tempfile
import time
import shutil
import re

from subprocess import call
from datetime import timedelta
from datetime import datetime
from uuid import uuid4

CardboardScore = {
        'zero': 0,
        'general': 1,
        'agenda': 2,
        'bounty': 3,
        }

# Note: Tweak this, respecting the range [0, 7).
# This is meant to be compared against the weekdays statistics.
# Describes the importance of a task.
TodoRank = {
        'low': (range(0, 2), 2),
        'medium': (range(2, 5), 2),
        'high': (range(5, 7), 3),
        'hard': (range(5, 7), 4),
        'asap': (range(0, 7), 2),
        'routine': (range(1, 7), 1),
        }

# Note: Fixed TODOs won't get poped out from the agenda.
# Note to myself: why do i have shit like general and agenda here?
TodoKind = {
        'normal': 'general',
        'fixed': 'agenda',
        }

def calculate_weekdays_statistics(commits, today=None):
    """
    Returns a dict of weekdays' names and statistics.

    e.g.
            {
                'Sunday': 6,
                'Monday': 5,
                'Tuesday': 4,
                'Wednesday': 3,
                'Thursday': 2,
                'Friday': 1,
                'Saturday': 0
            }

    @commits: A list of commits from the json.
    """
    # Sums points and worked days of each weekday.
    points_per_weekday = {}
    today = datetime.today().strftime('%x') if today is None else today
    for date in commits:
        if date == today:
            break
        commit = commits[date]
        weekday = datetime.strptime(date, '%m/%d/%y').strftime('%A')

        if weekday in points_per_weekday:
            points_per_weekday[weekday]['points'] += commit['points']
            points_per_weekday[weekday]['average'] += 1
        else:
            points_per_weekday[weekday] = {'points': commit['points'], 'average': 1}

    # Calculates the average (points / worked days) of each weekday.
    weekdays_average = {
            'Sunday': 1,
            'Monday': 1,
            'Tuesday': 1,
            'Wednesday': 1,
            'Thursday': 1,
            'Friday': 1,
            'Saturday': 1
            }
    for wk in points_per_weekday:
        day = points_per_weekday[wk]
        weekdays_average[wk] = day['points'] / day['average']

    # Sort weekdays by their average.
    sorted_days = {}
    sorted_weekdays_average = sorted(weekdays_average.items(), key=lambda x: x[1])

    for idx, (day, avg) in enumerate(sorted_weekdays_average):
        sorted_days[day] = idx

    return sorted_days

def find_todays_prod(stats, today=None):
    """
    Returns the current day's weekday name, and its respective productivity.

    e.g. 'Monday', 5

    @stats: Expects its value from calculate_weekdays_statistics.
    """
    today = datetime.today() if today is None else datetime.strptime(today, '%m/%d/%y')
    today = today.strftime('%A')
    return today, stats[today]

def get_fitting_todos(data, stats, today=None):
    """
    Filters out less important tasks based upon weekday's statistics.

    @data:    The json's content.
    @stats:   Expects its value from find_todays_prod.
    """
    todos = data['todo']
    today = datetime.today().strftime('%x') if today is None else today
    done_todos = data['done_todo'][today]
    out_todos = []

    for uuid in todos:
        if uuid in done_todos:
            continue
        todo = todos[uuid]
        if stats in TodoRank[todo['rank']][0]:
            out_todos.append(uuid)

    return out_todos

def input_from_editor(description='', initial=''):
    """
    Fires up an editor with a temporary file, then reads back
    its content after the user closes it.

    @description: Some information the user might need to know (it goes into the file,
                  at the second line). Every line will start with a '#' character automatically, so
                  it gets ignored when reading back file's content.

    @initial:     The initial content for the file.
    """
    def add_comment(out, comment):
        comment = '# '.join(comment.splitlines(True))
        out.write(f'# {comment}\n'.encode())

    with tempfile.NamedTemporaryFile(suffix='.tmp') as f:
        if len(initial) > 0:
            f.write(initial.encode())
        if len(description) > 0:
            f.write('\n'.encode())
            add_comment(f, description)
            add_comment(f, 'Lines starting with # will be ignored.')
        f.flush()
        editor = os.environ.get('EDITOR', 'vi')
        call([editor, f.name])
        f.seek(0)
        message = b''
        for line in f:
            if len(line) > 0 and not line.decode().startswith('#'):
                message += line

    message = message.decode()

    if message.startswith('cancel'):
        print('canceling commit.', file=sys.stderr)
        sys.exit(0)

    return message.rstrip('\n')

def add_todo(args, data):
    """
    Adds a new TODO into the json.

    @args: Expects its value from argparse.

    TODO's json structure:

        "uuid (8 bytes)": {
            "kind": "fixed|normal",
            "rank": "low|medium|high|hard|asap|routine",
            "descr": "description message",
        }
    """
    filename = args.filename
    rank = args.rank
    kind = args.kind
    description = 'Write what you should do in one line.\n' \
                  'This is a ' + rank + ', ' + kind + ' TODO.'
    input = input_from_editor(description)
    todo = data['todo']
    unique = str(uuid4())[:8]
    todo[unique] = {'kind': kind, 'rank': rank, 'descr': input.rstrip('\n')}

def commit_task(score, data, message='', today=None):
    today = datetime.today().strftime('%x') if today is None else today
    if isinstance(score, str):
        task_kind = score
        points = CardboardScore[score]
    elif isinstance(score, tuple):
        task_kind = score[0]
        points = score[1]
    description = message + 'Write about what you\'ve just accomplished.\n' \
                            'A ' + task_kind + ' task is worth ' + str(points) + ' point(s).'
    input = input_from_editor(description)
    commits = data['commits']
    commits[today]['points'] = max(0, commits[today]['points'] + points)
    commits[today]['tasks'].append(task_kind.upper() + ': ' + input)

def generate_agenda_list(data, day, all=False, simple=True):
    commits = data['commits']
    todos = data['todo']
    done_todos = data['done_todo'][day]
    initial_message = ''
    description = 'Mark with `done` the tasks you\'ve accomplished.\n' \
                  'You can edit the TODOs\' descriptions.'

    if all:
        todo_list = []
        for uuid in todos:
            if uuid not in done_todos:
                todo_list.append(uuid)
    else:
        weekday, stats = find_todays_prod(calculate_weekdays_statistics(commits, day), day)
        todo_list = get_fitting_todos(data, stats, day)

    if simple:
        for uuid in todo_list:
            t = todos[uuid]
            initial_message += 'todo ' + uuid + ' ' + t['descr'] + '\n'
    else:
        for uuid in todo_list:
            t = todos[uuid]
            initial_message += 'todo ' + t['kind'] + ' ' + t['rank'] + ' ' + uuid + ' ' + t['descr'] + '\n'

    return description, initial_message

def parse_todo_lines(data, lines, simple=True, today=None):
    # e.g. 'todo cafebabe I wanna take denilson away.'
    #        -> ['todo', 'cafebabe', 'I wanna take amorim away.']
    todos = data['todo']
    done_todos = data['done_todo'][datetime.today().strftime('%x') if today is None else today]

    if simple is True:
        line_re = re.compile('^\s*(todo|done|forget)\s*([0-9a-f]{8})\s*(.*)$')
    else:
        line_re = re.compile('^\s*(todo|done|forget)\s*(normal|fixed)\s*(low|medium|high|hard|asap|routine)\s*([0-9a-f]{8})\s*(.*)$')

    for line in lines:
        m = line_re.match(line)
        if not m:
            continue

        if simple is True:
            status, uuid, descr = m.groups()
        else:
            status, kind, rank, uuid, descr = m.groups()
            assert kind in TodoKind.keys(), "Kind shall be one of: " + str(list(TodoKind.keys()))
            assert rank in TodoRank.keys(), "Rank shall be one of: " + str(list(TodoRank.keys()))

        assert status in ['todo', 'done', 'forget'], "Status of a TODO is 'todo', 'done' or 'forget'."
        assert uuid in todos, uuid + " doesn't exist. Did you change anything?"
        assert len(descr) != 0, "No description provided for " + uuid + "."

        # Update todo's information.
        single_todo = todos[uuid]
        single_todo['descr'] = descr.rstrip('\n')

        if simple is False:
            single_todo['kind'] = kind
            single_todo['rank'] = rank

        if status == 'done':
            if single_todo['kind'] == 'fixed':
                done_todos[uuid] = single_todo
            else:
                done_todos[uuid] = todos.pop(uuid)
            points = TodoRank[single_todo['rank']][1]
            commit_task(score=('agenda', points), data=data, message='Committing ' + uuid + ' ' + descr + '\n', today=today)
        elif status == 'forget':
            todos.pop(uuid)

def manage_todos(data, all=False, simple=True, today=None):
    """
    The user Interactively marks TODOs as done in the json.

    @data: The json's content.
    """
    today = datetime.today().strftime('%x') if today is None else today
    description, initial_message = generate_agenda_list(data=data, day=today, all=all, simple=simple)

    if len(initial_message) == 0:
        print('Congratulations! You\'ve done everything today. Time to have fun.')
        return

    input = input_from_editor(description, initial_message)

    # At this point, assume `input` has a list of "status uuid description"
    # kind of lines. Ignore everything else.
    parse_todo_lines(data, input.split('\n'), simple, today)

def manage_agenda(args, data):
    day = (datetime.today() - timedelta(days=1)).strftime('%x') if args.yesterday else None
    manage_todos(data=data, all=True, simple=not args.complete, today=day)

def add_task(args, data):
    day = (datetime.today() - timedelta(days=1)).strftime('%x') if args.yesterday else None
    score = args.score
    if score == 'agenda':
        manage_todos(data=data, today=day)
    else:
        commit_task(score=score, data=data, today=day)

def dump_tasks(args, data):
    target_date = args.date
    dump_all = args.all
    term_width = shutil.get_terminal_size().columns
    header = '-' * term_width
    commits = data['commits']

    def dump_task(day):
        print(day)
        if day not in commits or commits[day]['points'] == 0:
            print("Completely stupid zero day this one is. What a shame.")
        else:
            points = commits[day]['points']
            print('points:', points, '\n')
            for task in commits[day]['tasks']:
                if args.oneline is True:
                    print(io.StringIO(task).readline().rstrip('\n'))
                else:
                    print(task)
            print(header)

    if target_date is not None:
        if target_date in commits:
            dump_task(target_date)
        else:
            raise KeyError(args.date + " doesn't exist.")
    elif dump_all is True:
        for day in commits:
            dump_task(day)
    else:
        dump_task(datetime.today().strftime('%x'))

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Zero days? No more.')
    subparsers = parser.add_subparsers()

    parser_new_task = subparsers.add_parser('commit')
    parser_new_task.add_argument('score', choices=list(CardboardScore.keys()))
    parser_new_task.add_argument('--yesterday', dest='yesterday', action='store_true')
    parser_new_task.set_defaults(func=add_task)

    parser_dump_task = subparsers.add_parser('dump')
    parser_dump_task.add_argument('--date', dest='date', default=None)
    parser_dump_task.add_argument('--all', dest='all', action='store_true')
    parser_dump_task.add_argument('--oneline', dest='oneline', action='store_true')
    parser_dump_task.add_argument('--yesterday', dest='yesterday', action='store_true')
    parser_dump_task.set_defaults(func=dump_tasks)

    parser_todo = subparsers.add_parser('todo')
    parser_todo.add_argument('kind', choices=list(TodoKind.keys()))
    parser_todo.add_argument('rank', choices=list(TodoRank.keys()))
    parser_todo.add_argument('--yesterday', dest='yesterday', action='store_true')
    parser_todo.set_defaults(func=add_todo)

    parser_agenda = subparsers.add_parser('agenda')
    parser_agenda.add_argument('--complete', dest='complete', action='store_true')
    parser_agenda.add_argument('--yesterday', dest='yesterday', action='store_true')
    parser_agenda.set_defaults(func=manage_agenda)

    parser.add_argument('-o', dest='filename', default='/home/thlst/usr/zeroday/zerodays.json', help='Data file.')
    args = parser.parse_args(sys.argv[1:])

    with io.open(args.filename, 'a+') as f:
        if os.path.getsize(args.filename) == 0:
            f.write('{"commits": {}, "todo": {}, "done_todo": {}}')

    with io.open(args.filename, 'r') as f:
        data = json.load(f)
        today = (datetime.today() - timedelta(days=1)).strftime('%x') if args.yesterday else datetime.today().strftime('%x')
        if today not in data['commits']:
            data['commits'][today] = {'points': 0, 'tasks': []}
        if today not in data['done_todo']:
            data['done_todo'][today] = {}

    args.func(args, data)

    with io.open(args.filename, 'w') as f:
        json.dump(data, f)
    shutil.copyfile(args.filename, f'{args.filename}.bkp')

