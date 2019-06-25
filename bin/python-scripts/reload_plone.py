#!/Users/bernd/.pyenv/versions/Scripts/bin/python
# Reload python code for plone by calling /reload?action=code
__author__ = 'Nachtalb'
__version__ = '1.0.1'
__date__ = '2019-02-19'
import sys

from argparse import ArgumentParser, SUPPRESS

from requests_html import HTMLSession
from requests.exceptions import ConnectionError, Timeout

parser = ArgumentParser('Reload Plone', add_help=False)

parser.add_argument('--help', action='help', default=SUPPRESS, help='Show this help message and exit')
parser.add_argument('-p', '--port', help='Port', default=8080)
parser.add_argument('-h', '--host', help='Hostname', default='localhost')
parser.add_argument('-u', '--user', help='Username', default='admin')
parser.add_argument('-w', '--password', help='Password', default='admin')

args = parser.parse_args()

session = HTMLSession()
try:
    response = session.get(f'http://{args.host}:{args.port}/reload?action=code', auth=(args.user, args.password), timeout=3)
except (ConnectionError, Timeout):
    print('Page not online')
    sys.exit()

reload_info = response.html.xpath('//pre', first=True)
if reload_info is None:
    print(response.html.text.strip())
else:
    print(reload_info.full_text.strip())
