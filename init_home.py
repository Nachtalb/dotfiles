import os
import sys

BASE_PATH = os.path.dirname(os.path.realpath(os.path.abspath(__file__)))
HOME_PATH = os.path.expanduser('~')

DOTFILES_HOME_PATH = os.path.join(BASE_PATH, 'HOME_SYMLINKS')
STRUCTURE_HOME_PATH = os.path.join(BASE_PATH, 'HOME_STRUCTURE')

NOT_EXISTS = -1  # Target does not exist at all
LINK_CREATED = 0  # Linked
LINK_EXISTS = 1  # Linked
DIR_EXISTS = 2  # Not linked
FILE_EXISTS = 3  # Not linked
DIR_CREATED = 4  # Not linked
FILE_CREATED = 5  # Not linked


MESSAGES = {
    NOT_EXISTS: 'Target does not exist',
    LINK_CREATED: 'Link was created',
    LINK_EXISTS: 'Link already exists',
    DIR_EXISTS: 'Directory already exists (not linked)',
    FILE_EXISTS: 'File already exists (not linked)',
    DIR_CREATED: 'Directory was created (not linked)',
    FILE_CREATED: 'File was created (not linked)',
}

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
        return LINK_EXISTS
    elif os.path.isdir(target) and os.path.realpath(target) != source:
        return DIR_EXISTS
    elif os.path.isfile(target):
        if os.path.realpath(target) != source:
            return FILE_EXISTS
        return LINK_EXISTS

    os.symlink(source, target)
    return LINK_CREATED


def print_title(message):
    line = '-' * len(message)
    print(f'\n{message}\n{line}')


print_title('CREATING STRUCTURE')
source_length = len(max(recursive_get_file(STRUCTURE_HOME_PATH, True, files=False), key=len))

for directory in recursive_get_file(STRUCTURE_HOME_PATH, True, files=False):
    target = os.path.join(HOME_PATH, directory.replace(STRUCTURE_HOME_PATH + '/', ''))
    state = NOT_EXISTS

    if not os.path.isdir(target):
        os.makedirs(target, exist_ok=True)
        state = DIR_CREATED
    elif os.path.realpath(target) == directory:
        state = LINK_EXISTS
    else:
        state = DIR_EXISTS
    no_msg = 'NO ' if state == LINK_EXISTS is False else ''
    print(f'OK: {directory: <{source_length}} -> {target} >> {MESSAGES[DIR_EXISTS]}')

print_title('CREATING SYMLINKS')
skip_folders = []
source_length = len(max(recursive_get_file(DOTFILES_HOME_PATH, True), key=len))

for node in recursive_get_file(DOTFILES_HOME_PATH, True):
    target = os.path.join(HOME_PATH, node.replace(DOTFILES_HOME_PATH + '/', ''))
    state = create_symlink(node, target)

    no_msg = 'NO ' if state == FILE_EXISTS is False else ''
    print(f'{no_msg}OK: {node: <{source_length}} -> {target} >> {MESSAGES[state]}')
