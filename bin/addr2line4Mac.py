#!/usr/bin/python

import sys, re, subprocess

filename=sys.argv[1]
address=sys.argv[2]

p = subprocess.Popen("/usr/bin/gdb -batch -x /dev/stdin",
                     shell=True,
                     bufsize=0,
                     stdin=subprocess.PIPE,
                     stdout=subprocess.PIPE,
                     close_fds=True)

(child_stdin, child_stdout) = (p.stdin, p.stdout)
child_stdin.write("set sharedlibrary preload-libraries no\n")
child_stdin.write("file "+filename+"\n")
child_stdin.write("info line *"+address+"\n")
result=child_stdout.readline()

answer="??:0"

match=re.compile('Line (.+) of "(.+)" starts at').match(result)
if match:
    answer=match.group(2)+":"+match.group(1)
print answer,

sys.exit(255)
