#!/Users/bernd/.pyenv/versions/Scripts/bin/python
# This script automatically links PyCharm's PyDevD egg to ~/Development/pycharm-debug.egg

import os
import sys
import shutil
from argparse import ArgumentParser

from pathlib import Path

HOME = Path(os.path.expanduser('~'))
PYCHARM_INSTALLATION_LOCATION = Path(HOME) / 'Library/Application Support/JetBrains/Toolbox/apps/PyCharm-P/ch-0'
DESTINATION_LOCATION = HOME / 'Development/pycharm-debug.egg'


def fix_path(source_file=None, destination_file=None):
    original_egg = None
    latest_pycharm_app = None

    if source_file and str(source_file).endswith('.app'):
        latest_pycharm_app = source_file
    elif source_file and str(source_file).endswith('.egg'):
        original_egg = source_file
    elif source_file:
        apps = sorted(list(source_file.glob('*.app')))
        if not apps:
            print(f'No PyCharm ".app"\'s found in {source_file}')
            return
        latest_pycharm_app = apps[-1]
    else:
        latest_pycharms = sorted(list(PYCHARM_INSTALLATION_LOCATION.glob('*')))[-1]
        apps = list(latest_pycharms.glob('*.app'))
        if not apps:
            print(f'Could not detect latest PyCharm application')
            return
        latest_pycharm_app = apps[-1]

    if latest_pycharm_app and not original_egg:
        original_egg = latest_pycharm_app / 'Contents/debug-eggs/pycharm-debug.egg'

    if not original_egg.exists():
        print('Could not find latest PyCharm')
        return

    link_path = Path(destination_file or DESTINATION_LOCATION)
    if link_path.exists():
        backup = link_path.with_suffix('.bak')
        print(f'File or Dir was at destination location. Moved from {link_path} --> {backup}')
        shutil.move(link_path, backup)
    elif link_path.is_symlink():
        os.unlink(str(link_path))

    os.symlink(original_egg, link_path)
    return original_egg, link_path


if __name__ == '__main__':
    parser = ArgumentParser('PyCharm Debug Egg Linker')
    parser.add_argument('-s', help='Source path')
    parser.add_argument('-d', help='Destination path')
    args = parser.parse_args()

    if args.s and not os.path.isfile(args.s) and not os.path.islink(args.s):
        print(f'Path: "{args.s}" does not exist')
        sys.exit(1)

    original_file, linked_file = fix_path(args.s, args.d) or (None, None)
    if linked_file is None:
        sys.exit(1)
    else:
        print(f'File linked from "{original_file}" --> "{linked_file}"')
