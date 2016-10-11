from __future__ import print_function
import sys


lines = sys.stdin.readlines()

min_recall = float(lines[-1].split(' ')[2])


norm = min_recall

print(lines[0], end='')

for line in lines[1:]:
    args = line.strip().split(' ')

    args[2] = str((float(args[2]) - norm) / (1 - norm))

    print(' '.join(args))
