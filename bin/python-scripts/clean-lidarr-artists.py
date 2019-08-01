#!/Users/bernd/.pyenv/versions/Scripts/bin/python
# Delete Artists on a lidarr
#
# Deletes artists which have less or equals to the given amount of tracks.
# This can help clean up a bit when importing artists from other sources, where it can happen that lidarr finds the
# wrong artist (which have 0 tracks or just a few like 5).
__author__ = 'Nachtalb'
__version__ = '1.0.0'
__date__ = '2019-07-31'

from contextlib import closing
from lidarr import LidarrAPI
from pathlib import Path
from tabulate import tabulate
from argparse import ArgumentParser

import json

parser = ArgumentParser()
parser.add_argument('url', help='Lidarr web root')
parser.add_argument('api', help='Lidarr API token')
parser.add_argument(
    '--track-amount',
    default=5,
    type=int,
    help='Minimum amount of tracks required per artist for it to be not removed. Defaults to 5.'
)
parser.add_argument(
    '--file',
    help='File to load the artists from instead of requesting them from lidarr itself.'
)

args = parser.parse_args()


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


artists = None

if args.file:
    path = Path(args.file)
    if not path.is_file():
        print('Given path is not a file')

    with closing(path.open()) as f:
        artists = json.load(f)

la = LidarrAPI(args.url, args.api)

if not artists:
    print('Fetching artists')
    artists = la.artists()

print('Processing artists')
applicable = list(filter(lambda o: o['statistics']['totalTrackCount'] < args.track_amount, artists))


def print_artists(artists):
    data = [[
        'ID', 'Name', 'Type', 'Albums', 'Tracks'
    ]]

    for artist in artists:
        data.append([
            artist['id'],
            artist['artistName'],
            artist.get('artistType', ''),
            artist['statistics']['albumCount'],
            f"{artist['statistics']['trackFileCount']}/{artist['statistics']['totalTrackCount']}",
        ])

    print(tabulate(data))


def filter_step(artists):
    print_artists(artists)
    filtered = artists[:]

    print()
    print('If you want some artists to not be deleted give me a by comma separated list of ids or press enter to continue.')
    print('=' * 80)

    given = input('IDs: ').strip()
    if given:
        ids = list(map(int, map(str.strip, given.split(','))))

        for artist in filtered[:]:
            if artist['id'] in ids:
                filtered.remove(artist)

    return filtered


ok = False
filtered = applicable
while not ok:
    before_filter = filtered
    filtered = filter_step(filtered)

    if before_filter == filtered:
        ok = True

print_artists(filtered)
if input('Are you sure to delete those [n/Y]: ').startswith('n'):
    exit

print('Deleting artists')
for index, artist in enumerate(filtered):
    print(f'Delete {artist["id"]} [{index}/{len(filtered)}]')
    try:
        la.artist_delete(artist['id'], delete_files=True)
    except Exception as e:
        print(f'Could not delete {artist["id"]}')
        print(e)
