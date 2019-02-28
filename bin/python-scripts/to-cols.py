#!~/.pyenv/versions/Scripts/bin/python
# Split text to cols
import argparse
import sys

__author__ = 'Nachtalb'
__version__ = '1.0.0'
__date__ = '2019-02-26'

parser = argparse.ArgumentParser()
parser.add_argument('-n', '--number', type=int, help='Number of columns (defaults to 3)', default=3)
parser.add_argument('-d', '--delimiter', type=str, help='Delimiter (defaults to \\n)', default='\n')
parser.add_argument('-m', '--margin', type=int, help='Margin between cols (defaults to 4)', default=3)
args = parser.parse_args()


def split(a, n):
    k, m = divmod(len(a), n)
    return (a[i * k + min(i, m):(i + 1) * k + min(i + 1, m)] for i in range(n))


text = sys.stdin.read()
cell_values = list(filter(None, map(str.strip, text.split(args.delimiter))))

if not cell_values:
    sys.exit()

split_cells = list(split(cell_values, args.number))

col_lengths = [len(max(l, key=len)) + args.margin for l in split_cells]

template = ''.join('{: <%s}' % l for l in col_lengths)

for row in zip(*split_cells):
    print(template.format(*row))
