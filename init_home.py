import os
import sys

BASE_PATH = os.path.dirname(os.path.realpath(os.path.abspath(__file__)))
HOME_PATH = os.path.expanduser('~')

DOTFILES_HOME_PATH = os.path.join(BASE_PATH, 'home_dir')
STRUCTURE_HOME_PATH = os.path.join(BASE_PATH, 'home_structure')

if not os.path.isdir(DOTFILES_HOME_PATH):
    print(f'No path {DOTFILES_HOME_PATH} found.')
    sys.exit(1)


def recursive_get_file(path, ignore_current=False, dirs=True, files=True):
    if not ignore_current and dirs:
        yield path
    for node in os.listdir(path):
        node_path = os.path.join(path, node)

        if os.path.isdir(node_path):
            yield from recursive_get_file(node_path, dirs=dirs, files=files)
        elif files:
            yield node_path


def create_symlink(source, target):
    if os.path.isdir(target) and os.path.realpath(target) == source:
        return
    elif os.path.isfile(target):
        if os.path.realpath(target) != source:
            return f'Could not link "{source}" to "{target}" because file already exists'
        return
    elif os.path.isdir(target) and os.path.isdir(source):
        return

    print(f'Symlinked "{source}" to "{target}"')
    os.symlink(source, target)
    return True


def print_title(message):
    line = '-' * len(message)
    print(f'\n{message}\n{line}')


print_title('CREATING STRUCTURE')
for directory in recursive_get_file(STRUCTURE_HOME_PATH, True, files=False):
    target = os.path.join(HOME_PATH, directory.replace(STRUCTURE_HOME_PATH + '/', ''))
    if not os.path.isdir(target):
        os.makedirs(target, exist_ok=True)
        print(f'Created directory "{target}"')
    print(f'OK: {target}')

print_title('CREATING SYMLINKS')
skip_folders = []
for node in recursive_get_file(DOTFILES_HOME_PATH, True):
    target = os.path.join(HOME_PATH, node.replace(DOTFILES_HOME_PATH + '/', ''))
    if any(map(lambda item: node.startswith(item), skip_folders)):
        print(f'OK: {target}')
        continue

    created = create_symlink(node, target)
    if os.path.isdir(node) and not created:
        skip_folders.append(node)

    if created not in [None, True]:
        print(f'NOT OK: {target} >> {created}')
    print(f'OK: {target}')
