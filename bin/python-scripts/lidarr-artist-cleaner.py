#!/Users/bernd/.pyenv/versions/Scripts/bin/python
# Delete Artists on a lidarr
#
# Deletes artists which have less or equals to the given amount of tracks.
# This can help clean up a bit when importing artists from other sources, where it can happen that lidarr finds the
# wrong artist (which have 0 tracks or just a few like 5).
__author__ = 'Nachtalb'
__version__ = '1.1.0'
__date__ = '2019-08--5'

from contextlib import closing
from lidarr import LidarrAPI
from pathlib import Path
from tabulate import tabulate
from argparse import ArgumentParser

import json
import sys


class LidarrCleaner:
    def __init__(self, url, api):
        self.la = LidarrAPI(url, api)
        self.artists = []
        self.original_artists = []
        self.deleted_artists = []

    def load_file(self, file_path):
        path = Path(file_path)
        with closing(path.open()) as f:
            self.artists = json.load(f)
            self.original_artists = self.artists[:]

    def fetch_artists(self):
        self.artists = self.la.artists()
        self.original_artists = self.artists[:]

    def print_artists(self, artists=None):
        artists = artists or self.artists
        data = [[
            'ID', 'Name', 'Type', 'Albums', 'Tracks'
        ]]

        for artist in sorted(artists, key=lambda o: o['sortName']):
            data.append([
                artist['id'],
                artist['artistName'],
                artist.get('artistType', ''),
                artist['statistics']['albumCount'],
                f"{artist['statistics']['trackFileCount']}/{artist['statistics']['totalTrackCount']}",
            ])

        print(tabulate(data))

    def delete_artists(self):
        print('Deleting artists')
        total_artists = len(self.artists)
        for index, artist in enumerate(self.artists[:]):
            print(f'Delete {artist["id"]} [{index}/{total_artists}]')
            try:
                self.la.artist_delete(artist['id'], delete_files=True)
                self.deleted_artists.append(artist)
                self.artists.remove(artist)
            except Exception as e:
                print(f'Could not delete {artist["id"]}')
                print(e)

    def filter_by_ids(self, ids):
        for artist in self.artists[:]:
            if artist['id'] in ids:
                self.artists.remove(artist)

    def filter_by_track_amount(self, min_track_amount):
        self.artists = list(filter(lambda o: o['statistics']['totalTrackCount'] < min_track_amount, self.artists))

    def filter_by_none_downloaded(self):
        self.artists = list(filter(lambda o: o['statistics']['trackFileCount'] == 0, self.artists))


def get_input(text, default=None):
    if default:
        text = text.strip()
        text = f'{text} [{default}] '

    given = None
    while not given:
        given = input(text).strip()
        if not given and default:
            return default
    return given


def manual_filter(cleaner):
    def filter_step(artists):
        cleaner.print_artists()

        print()
        print('If you want some artists to not be deleted give me a by comma separated list of ids or press enter to continue.')
        print('=' * 80)

        given = input('IDs: ').strip()
        if given:
            ids = list(map(int, map(str.strip, given.split(','))))
            cleaner.filter_by_ids(ids)

        return artists

    ok = False
    while not ok:
        before_filter = cleaner.artists[:]
        filtered = filter_step(cleaner.artists)

        if before_filter == filtered:
            ok = True


def cmd_main(*, url=None, api=None, file=None, track_amount=None, none_downloaded_mode=False):
    if not url:
        url = get_input('Lidarr URL root: ')

    if not api:
        api = get_input('Lidarr API token: ')

    if not track_amount and not none_downloaded_mode:
        track_amount = int(get_input('Minimum track amount:', default=5))

    cleaner = LidarrCleaner(url, api)

    fetch_artists = True
    if file:
        try:
            cleaner.load_file(file)
            fetch_artists = False
        except FileNotFoundError:
            print('Given path is not a file')
        except json.JSONDecodeError:
            print('Invalid JSON')

    if fetch_artists:
        print('Fetching artists')
        cleaner.fetch_artists()

    print('Processing artists')
    if none_downloaded_mode:
        cleaner.filter_by_none_downloaded()
    else:
        cleaner.filter_by_track_amount(track_amount)

    if not cleaner.artists:
        print('No applicable artists found')
        sys.exit()

    manual_filter(cleaner)
    while True:

        print('=' * 80)
        cleaner.print_artists()
        answer = input('Are you sure to delete those [N/y/f]: ').lower()

        if answer.startswith('n'):
            break
        elif answer.startswith('y'):
            cleaner.delete_artists()
            break
        elif answer.startswith('f'):
            manual_filter(cleaner)


def parse_cmd():
    parser = ArgumentParser()
    parser.add_argument('url', help='Lidarr web root')
    parser.add_argument('api', help='Lidarr API token')
    parser.add_argument(
        '--track-amount',
        type=int,
        help='Minimum amount of tracks required per artist for it to be not removed. Defaults to 5.'
    )
    parser.add_argument(
        '--file',
        help='File to load the artists from instead of requesting them from lidarr itself.'
    )
    parser.add_argument(
        '--none-downloaded',
        help='Mode to remove artists from which nothing has been downloaded',
        action='store_true'
    )

    return parser.parse_args()


if __name__ == '__main__':
    args = parse_cmd()
    try:
        cmd_main(
            url=args.url,
            api=args.api,
            track_amount=args.track_amount,
            file=args.file,
            none_downloaded_mode=args.none_downloaded
        )
    except KeyboardInterrupt:
        print('Exit')
