#!/bin/python3

import os
import sys
import subprocess

EXTENSION_MAP = {
    "mpv": {
        "mp3",
        "mp4",
        "ogg",
        "flac"
    },
    "zathura": {
        "pdf"
    },
    "sxiv": {
        "png",
        "jpg",
        "gif",
    },
    "firefox": {
        "html"
    },
    "nvim": {
        "c",
        "cpp",
        "cxx",
        "js",
        "txt",
        "sh",
        "md",
    }
}

def file_extension(filepath):
    if "." in filepath:
        ext = os.path.splitext(filepath)[1]
        return ext[1:] # Remove dot (.) from extension
    else:
        raise RuntimeError(f"file `{filepath}` has no extension")

def find_program_for_extension(ext):
    for program in EXTENSION_MAP:
        if ext in EXTENSION_MAP[program]:
            return program
    return None

def main(filepath):
    ext = file_extension(filepath)
    program = find_program_for_extension(ext)
    
    if program:
        os.execlp(program, program, filepath)
        # return subprocess.call([program, filepath])
    else:
        print(f"no program found for `{filepath}`", file=sys.stderr)
        return 1

def usage(program):
    print(f"USAGE: {os.path.basename(program)} /path/to/file",
          file=sys.stderr)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        usage(sys.argv[0])
        sys.exit(1)

    try:
        sys.exit(main(sys.argv[1]))
    except RuntimeError as e:
        print(f"error: {e}", file=sys.stderr)
