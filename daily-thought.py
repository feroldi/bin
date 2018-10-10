#!/usr/bin/env python3

import datetime
import io
import os
import subprocess
import argparse
import pathlib

if __name__ == '__main__':
    args = argparse.ArgumentParser()
    args.add_argument(
        '-d',
        '--date',
        metavar='YYYY-MM-DD',
        help='specify the date of the report in UTC format')
    args.add_argument(
        '-o',
        '--out-dir',
        metavar='PATH',
        default='./',
        help='the output directory')

    opts = args.parse_args()

    log_date_utc = datetime.datetime.fromisoformat(
        opts.date) if opts.date else datetime.datetime.now()
    log_file_path = f'{log_date_utc.date()}.md'
    log_file_path = pathlib.Path(opts.out_dir, log_file_path)

    log_file_path.parent.mkdir(parents=True, exist_ok=True)

    initial_header = '\n' if log_file_path.is_file(
    ) else f'# DAILY THOUGHT: {log_date_utc.date()}\n\n'

    with io.open(log_file_path, mode='a', encoding='utf-8') as out:
        out.write(initial_header)

    editor = os.environ.get('EDITOR', 'vi')
    command = [editor]
    if editor in ['vi', 'vim', 'nvim']:
        # Move the cursor to the last line of the file.
        command.append('+')
    command.append(log_file_path)
    subprocess.run(command)

    if subprocess.run(['git', 'status'], cwd=log_file_path.parent) == 0:
        subprocess.run(
            ['git', 'add', log_file_path.as_posix()], cwd=log_file_path.parent)
        subprocess.run(['git', 'commit'], cwd=log_file_path.parent)
