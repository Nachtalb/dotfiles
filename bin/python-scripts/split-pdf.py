#!/Users/bernd/.pyenv/versions/Scripts/bin/python
import argparse
import os

try:
    from PyPDF2 import PdfFileReader, PdfFileWriter
except ImportError:
    print('Make sure PyPDF2 is installed')
    exit(1)

parser = argparse.ArgumentParser()
parser.add_argument('file')
parser.add_argument('split', nargs='+', help='From where to where the PFF shall be split. Eg. 0-4 5-7 9-10')
args = parser.parse_args()

if not os.path.isfile(args.file):
    print(f'File {args.file} does not exits')
    exit(1)

dirname = os.path.dirname(args.file)
filename = os.path.splitext(os.path.basename(args.file))[0]

pages = [[int(page) for page in page_range.split('-')] for page_range in args.split]
corrupt = list(filter(lambda item: item[0] > item[1], pages))

if corrupt:
    print('First page number can\'t be higher than second.')
    for fault in corrupt:
        print(fault)
    exit(1)

input_file = PdfFileReader(open(args.file, 'rb'))

for index, page_range in enumerate(pages):
    if len(page_range) == 1:
        page_range = page_range.append(input_file.numPages)

    if page_range[1] > input_file.numPages:
        print(f'Skip range {page_range}')
        continue

    output_file = PdfFileWriter()
    output_file_path = os.path.join(dirname, f'{filename}-{index}.pdf')

    for page_number in range(page_range[0], page_range[1] + 1):
        output_file.addPage(input_file.getPage(page_number))

    with open(output_file_path, 'wb') as output_stream:
        print(f'Writting file {output_file_path} with range {page_range}')
        output_file.write(output_stream)
