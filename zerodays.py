#!/bin/python

import json
import argparse
import sys, os, io
import tempfile
import time
import shutil

from subprocess import call

Score = {'zero': 0, 'general': 1, 'agenda': 2, 'bounty': 3}

def input_task_description(score):
    with tempfile.NamedTemporaryFile(suffix='.tmp') as f:
        editor = os.environ.get('EDITOR', 'vi')
        call([editor, f.name])
        f.seek(0)
        message = f.read()
    return Score[score], message.decode()

def reserve_space(data, date):
    if date not in data:
        data[date] = {}
        data[date]["points"] = 0
        data[date]["tasks"] = []
    return data

def add_task(args):
    today = time.strftime('%x')
    points, msg = input_task_description(args.score)
    with io.open(args.filename, 'r') as f:
        data = reserve_space(json.load(f), today)
    data[today]['points'] = max(0, data[today]['points'] + points)
    data[today]['tasks'].append(args.score.upper() + ': ' + msg)
    with io.open(args.filename, 'w') as f:
        json.dump(data, f)

def dump_tasks(args):
    term_width = shutil.get_terminal_size().columns
    header = '-' * term_width
    with io.open(args.filename, 'r') as f:
        data = json.load(f)

    def dump_task(day):
        print(day)
        if day not in data or data[day]['tasks'] is []:
            print("It seems there isn't anything to see here.")
        else:
            points = data[day]['points']
            print('COMMITS:', points, '#' * points, '\n')
            for task in data[day]['tasks']:
                if args.oneline is True:
                    print(io.StringIO(task).readline().rstrip('\n'))
                else:
                    print(task)
            print(header)

    if args.average is True:
        points = 0
        tasks = 0
        for day in data:
            if data[day]['points'] == 0:
                points -= 3;
            else:
                points += data[day]['points']
            tasks += len(data[day]['tasks'])
        print('TOTAL COMMITS:', points, '#' * min(points, term_width - 17))
        print('TOTAL TASKS:  ', tasks, '#' * min(tasks, term_width - 17))
    else:
        if args.date is not None:
            if args.date in data:
                dump_task(args.date)
            else:
                raise KeyError(args.date + " doesn't exist.")
        elif args.all is True:
            for day in data:
                dump_task(day)
        else:
            dump_task(time.strftime('%x')) # shows today's tasks

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Zero days? No more.')
    subparsers = parser.add_subparsers()
    parser_new_task = subparsers.add_parser('add')
    parser_new_task.add_argument('score', choices=list(Score.keys()))
    parser_new_task.set_defaults(func=add_task)
    parser_dump_task = subparsers.add_parser('dump')
    parser_dump_task.add_argument('--date', dest='date', default=None)
    parser_dump_task.add_argument('--all', dest='all', action='store_true')
    parser_dump_task.add_argument('--average', dest='average', action='store_true')
    parser_dump_task.add_argument('--oneline', dest='oneline', action='store_true')
    parser_dump_task.set_defaults(func=dump_tasks)
    parser.add_argument('-o', dest='filename', default='/home/thlst/usr/zeroday/zerodays.json', help='Data file.')
    args = parser.parse_args(sys.argv[1:])
    with io.open(args.filename, 'a+') as f:
        if os.path.getsize(args.filename) == 0:
            f.write('{}')
    args.func(args)

