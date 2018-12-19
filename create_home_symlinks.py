import os
import sys

BASE_PATH = os.path.dirname(os.path.realpath(os.path.abspath(__file__)))
HOME_PATH = os.path.expanduser('~')

DOTFILES_HOME_PATH = os.path.join(BASE_PATH, 'home_dir')

if not os.path.isdir(DOTFILES_HOME_PATH):
    print(f'No path {DOTFILES_HOME_PATH} found.')
    sys.exit(1)


def recursive_get_file(path, ignore_current=False):
    if not ignore_current:
        yield path
    for node in os.listdir(path):
        node_path = os.path.join(path, node)

        if os.path.isdir(node_path):
            yield from recursive_get_file(node_path)
        else:
            yield node_path


def create_symlink(source, target):
    if os.path.isdir(target) and os.path.realpath(target) == source:
        return False
    elif os.path.isfile(target):
        print(f'Could not link "{source}" to "{target}" because file already exists')
        return False
    elif os.path.isdir(target) and os.path.isdir(source):
        return False

    os.symlink(source, target)
    return True


def link_to_home(source):
    target = os.path.join(HOME_PATH, source.replace(DOTFILES_HOME_PATH + '/', ''))
    return create_symlink(source, target)


skip_folders = []
for node in recursive_get_file(DOTFILES_HOME_PATH, True):
    if any(map(lambda item: node.startswith(item), skip_folders)):
        continue
    created = link_to_home(node)
    if os.path.isdir(node) and not created:
        skip_folders.append(node)


