import curses
import os
import sys
from datetime import datetime
from pathlib import Path

from subprocess import call
from typing import List, Tuple


# Remember curses uses coordinates as [Y X] instead of the commonly used [X Y]

class ScrollableWindow:
    lines = {}

    def __init__(self, height: int, width: int, y: int, x: int):
        self.active_line = 0
        self.window = curses.newwin(height, width, y, x)
        self.scroll_pos = 0

    def reset(self):
        self.scroll_pos = 0
        self.active_line = 0
        self.lines = {}

    def draw(self, reset: bool = False):
        self.window.clear()
        if reset:
            self.reset()
        elif self.lines:
            to_draw = list(self.lines.keys())[self.scroll_pos:]
            height, width = self.window.getmaxyx()
            for line_nr, node_nr in enumerate(to_draw):
                if line_nr >= height:
                    break
                self.window.addstr(line_nr, 0, self.lines[node_nr],
                                   curses.A_REVERSE if node_nr == self.active_line else 0)
        self.window.refresh()

    def up(self, lines: int = None) -> int:
        lines = lines or 1
        new_active = self.active_line - lines
        if new_active < 0:
            new_active = 0
        self.active_line = new_active
        if self.active_line < self.scroll_pos:
            self.scroll_pos = self.active_line
        return self.active_line

    def down(self, lines: int = None) -> int:
        lines = lines or 1
        new_active = self.active_line + lines
        if new_active + 1 > len(self.lines):
            new_active = len(self.lines) - 1
        self.active_line = new_active

        height = self.window.getmaxyx()[0]
        if self.active_line >= height:
            if self.active_line + 1 == len(self.lines):
                self.scroll_pos = len(self.lines) - height
            elif abs(self.scroll_pos - self.active_line) == height:
                self.scroll_pos += 1
        return self.active_line

    def addstr(self, y: int, string: str):
        self.lines[y] = string


class FileBrowser:
    SORT_NAME = 'name'
    SORT_TYPE = 'type'
    SORT_TIME_MODIFIED = 'time (modified)'
    SORT_TIME_ADDED = 'time (added)'

    SHORT_SORT = {
        'n': SORT_NAME,
        't': SORT_TYPE,
        'm': SORT_TIME_MODIFIED,
        'x': SORT_TIME_ADDED,
    }

    sort_on = SORT_NAME
    sort_reverse = False

    first_dir = Path().absolute()
    _current_dir: Path
    last_dirs: List[Path]

    current_dir_file = Path('~/.explorer_dir').expanduser()

    node_list: List[Tuple[Path, str]]
    current_node: int

    def __init__(self, window, dir: Path or str = None) -> None:
        self.first_dir = dir or self.first_dir
        if not isinstance(self.first_dir, Path):
            self.first_dir = Path(dir)
        self.current_dir = self.first_dir
        self.last_dirs = []

        self.window = window
        self.window.clear()
        # rectangle(self.window, 0, 0, curses.LINES - 1, curses.COLS - 2)
        self.window.box()
        self.file_window = ScrollableWindow(curses.LINES - 4, curses.COLS - 3, 3, 1)

        curses.use_default_colors()

        self.cd(self.first_dir)
        self._main_loop()

    @property
    def current_dir(self):
        return self._current_dir

    @current_dir.setter
    def current_dir(self, value):
        self._current_dir = Path(value)
        self.current_dir_file.write_text(self._current_dir.as_posix())

    def hr(self, line: int):
        self.window.hline(line, 1, curses.ACS_HLINE, curses.COLS - 3)

    def _main_loop(self):
        while True:
            key = self.window.getkey()

            if key in ['k', 'w', 'KEY_SR']:
                self.key_up()
            elif key in ['j', 's', 'KEY_SF']:
                self.key_down()
            elif key in ['KEY_PPAGE']:
                self.key_up(10)
            elif key in ['KEY_NPAGE']:
                self.key_down(10)
            elif key in [' ', 'l', 'd']:
                self.key_enter()
            elif key in ['n', 't', 'm', 'x']:
                self.change_sort(key)
            elif key in ['KEY_HOME']:
                self.cd(self.first_dir)
            elif key in ['KEY_BACKSPACE']:
                self.last_dir()
            elif key in ['h', 'a']:
                self.cd(self.current_dir / '..')
            elif key in ['q']:
                os.system(f'cd {self.current_dir.as_posix()}')
                sys.exit(0)

    def shorten_path(self, path: str) -> str:
        if not path:
            return ''
        prefix = ''
        if path[0] in ['/', '.', '~']:
            prefix = path[0]
            path = path[1:]
        path = path.rstrip('/')
        parts = path.split('/')

        if len(parts) < 2:
            return f'{prefix}{path}'

        shortened = '/'.join(map(lambda part: part[0], parts[:-1]))
        return f'{prefix}{shortened}/{parts[-1]}'

    def sort(self):
        if self.sort_on == self.SORT_NAME:
            self.node_list = list(sorted(self.node_list, key=lambda item: item[0].name))
        elif self.sort_on == self.SORT_TYPE:
            self.node_list = list(sorted(self.node_list, key=lambda item: item[0].name.rsplit('.', 1)[-1]))
        elif self.sort_on == self.SORT_TIME_MODIFIED:
            self.node_list = list(sorted(self.node_list, key=lambda item: item[0].lstat().st_mtime))
        elif self.sort_on == self.SORT_TIME_ADDED:
            self.node_list = list(sorted(self.node_list, key=lambda item: item[0].lstat().st_atime))

        if self.sort_reverse:
            self.node_list = list(reversed(self.node_list))

    def _refresh(self):
        self.window.noutrefresh()
        self.file_window.draw()
        curses.doupdate()

    def _draw_title(self):
        self.window.addstr(1, 1, ' ' * (curses.COLS - 2))
        self.window.addstr(1, 1, f'Current dir: {self.shorten_path(self.current_dir.as_posix())}'
        f'\tSorting on: {self.sort_on}', curses.A_BOLD)
        self.hr(2)

    def _draw(self):
        self._draw_title()
        self._draw_dir(get_files=True)
        self._refresh()

    def _draw_dir(self, get_files: bool = False):
        if get_files:
            self.node_list = []
            self.node_list.append(((self.current_dir / '..').absolute(), '..'))
            self.node_list.extend(list(map(lambda item: (item, item.name), self.current_dir.glob('*'))))
            self.sort()
            self.file_window.reset()

        for line, file in enumerate(self.node_list):
            path, name = file

            try:
                type = 'f'
                suffix = ''
                if path.is_dir():
                    type = 'd'
                elif path.is_symlink():
                    type = 's'
                    suffix = f' --> {path.resolve().as_posix()}'

                modified = datetime.fromtimestamp(path.lstat().st_mtime).strftime('%Y-%m-%d %H:%M.%S')
                self.file_window.addstr(line, f'{line:0>3}| T: {type}  M: {modified} | {name}{suffix}')
            except PermissionError:
                self.file_window.addstr(line, f'{line:0>3}| T:    M:                     | {name}')

    def cd(self, new_dir):
        if self.current_dir:
            self.last_dirs.append(self.current_dir)
        self.current_dir = new_dir.resolve()
        self._draw()

    def last_dir(self):
        if not self.last_dirs:
            return
        self.current_dir = self.last_dirs.pop()
        self._draw()

    def key_up(self, lines: int = None):
        self.file_window.up(lines)
        self._refresh()

    def key_down(self, lines: int = None):
        self.file_window.down(lines)
        self._refresh()

    def key_enter(self):
        path = self.node_list[self.file_window.active_line][0]
        try:
            if path.resolve().is_dir():
                self.cd(path)
            elif path.resolve().is_file():
                editor = os.environ.get('EDITOR', 'vim')
                call([editor, path.resolve().as_posix()])
                self._draw()

        except PermissionError:
            self.last_dir()

    def change_sort(self, key):
        new_sort = self.SHORT_SORT.get(key, self.SORT_NAME)
        if self.sort_on == new_sort:
            self.sort_reverse = not self.sort_reverse
        self.sort_on = new_sort
        self._draw()


curses.wrapper(FileBrowser)
