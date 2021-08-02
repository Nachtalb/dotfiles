#!/home/bernd/.pyenv/versions/3.9.4/bin/python
from datetime import datetime
import json
from math import ceil
from pathlib import Path
import sys
from zipfile import ZipFile

try:
    options = []
    for arg in sys.argv[:]:
        if arg.startswith('-'):
            options.append(arg[1:])
            sys.argv.remove(arg)

    work_dir = Path()
    if len(sys.argv) > 1:
        possible_work_dir = Path(sys.argv[1])
        if possible_work_dir.is_dir():
            work_dir = possible_work_dir
            sys.argv.remove(sys.argv[1])

    if len(sys.argv) < 1:
        print('No mod given')

    with_index = len(sys.argv) > 2

    def clear(data, delimiter=', '):
        next_delimiter = '|' if delimiter == ', ' else ':'
        if isinstance(data, dict):
            return '\n'.join(map(lambda tpl: f'{tpl[0]}: {clear(tpl[1], next_delimiter)}', data.items()))
        elif isinstance(data, list):
            return delimiter.join(map(lambda item: clear(item, next_delimiter), data))
        return data


    if 'json' in options and with_index:
        print('[')

    search = {}


    def mod_info(file):
        with ZipFile(file) as zipfile:
            return json.loads(zipfile.open('fabric.mod.json').read().decode('utf-8').replace('\n', ''))


    def recursive_mod_info(file):
        info = mod_info(file)
        yield info
        for jar in map(lambda i: i['file'], info.get('jars', [])):
            with ZipFile(file) as zipfile:
                for child_info in recursive_mod_info(zipfile.open(jar)):
                    child_info['parent'] = info
                    yield child_info


    for index, mod in enumerate(sys.argv[1:], 1):
        file = work_dir / mod
        info, parent = None, None
        if not file.is_file():
            for file in work_dir.glob('*.jar'):
                for info in recursive_mod_info(file):
                    search[info['id']] = file
                    if info['id'] == mod:
                        break
                else:
                    continue
                break
            else:
                continue
            show_path = True
        else:
            show_path = False
            info = mod_info(file)

        if not info:
            continue

        stat = file.stat()
        fsize = '%dKB' % ceil(stat.st_size / 1024)
        last_modified = datetime.fromtimestamp(stat.st_mtime).strftime('%d-%m-%Y, %H:%M:%S')

        if options:
            if 'json' in options:
                end = ',\n' if with_index and index != len(sys.argv) - 1 else '\n'
                print(json.dumps(info, indent=4), end=end)
                continue

            to_print = []
            for option in options:
                if option in ['fsize', 'size']:
                    to_print.append(f'fsize: {fsize}')
                elif option in ['last_modified', 'last-modified', 'modified']:
                    to_print.append(f'last-modified: {last_modified}')
                elif option in ['depends', 'recommends', 'breaks', 'conflicts', 'suggests']:
                    to_print.append(
                        f'{option}: ' +
                        ', '.join([f'{key}: {value if isinstance(value, str) else "|".join(value)}' for key, value in info.get('depends', {}).items()])
                    )
                else:
                    data = clear(info.get(option))
                    if data:
                        to_print.append((f'{option}: ' if not isinstance(info.get(option), dict) else '') + data)
            print('\n'.join(to_print))
        else:
            print('\n'.join(map(lambda tpl: ''.join(tpl), filter(lambda tpl: tpl[1], [
                ('', f'{index}:' if with_index else ''),
                ('', f"[{info['id']}] {info['name']}"),
                ('Version: ', info['version']),
                ('Description: ', info.get('description')),
                ('Homepage: ', info.get('contact', {}).get('homepage')),
                ('Source: ', info.get('contact', {}).get('sources')),
                ('Issues: ', info.get('contact', {}).get('issues')),
                ('Dependencies: ', ', '.join([f'{key}: {value if isinstance(value, str) else "|".join(value)}' for key, value in info.get('depends', {}).items()])),
                ('Recommends: ', ', '.join([f'{key}: {value if isinstance(value, str) else "|".join(value)}' for key, value in info.get('recommends', {}).items()])),
                ('Filesize / Last modified: ', f'{fsize} / {last_modified}'),
                ('Path: ', str(file) if show_path else ''),
                ('Parent: ', info.get('parent', {}).get('id')),
            ]))))

        if with_index and 'json' not in options:
            print()

    if 'json' in options and with_index:
        print(']')
except KeyboardInterrupt:
    pass
