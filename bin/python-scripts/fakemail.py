#!/Users/bernd/.pyenv/versions/Scripts/bin/python
#
# fakemail (Python version)
#
# Compatible with python 3.7
import asyncore
import os
import signal
import smtpd
import socket
import sys
from argparse import ArgumentParser, SUPPRESS

PROG_NAME = 'Fakemail'
ONLY_LOG = False
LOG_FILE = None


class FakeServer(smtpd.SMTPServer):
    RECIPIENT_COUNTER = {}

    def __init__(self, localaddr, remoteaddr, path):
        smtpd.SMTPServer.__init__(self, localaddr, remoteaddr)
        self.path = path

    def process_message(self, peer, mailfrom, rcpttos, data, **kwargs):
        message('Incoming mail')

        for recipient in rcpttos:
            if ONLY_LOG:
                message(f'Mail destined for {recipient}')
            else:
                str_data = data.decode('utf-8')

                message(f'Capturing mail to {recipient}' )
                count = self.RECIPIENT_COUNTER.get(recipient, 0) + 1
                self.RECIPIENT_COUNTER[recipient] = count
                filename = os.path.join(self.path, f'{recipient}.{count}')
                filename = filename.replace('<', '').replace('>', '')
                f = open(filename, 'w')
                f.write(str_data + '\n')
                print(str_data)
                f.close()
                message(f'Mail to {recipient} saved')
        message('Incoming mail dispatched')


def quit(reason=None):
    global PROG_NAME
    text = f'Stopping {PROG_NAME}'
    if reason is not None:
        text += f': {reason}'
    message(text)
    sys.exit()


def message(text):
    if LOG_FILE is not None:
        f = open(LOG_FILE, 'a')
        f.write(text + '\n')
        f.close()

    if not ONLY_LOG:
        print(text)


def handle_signals():
    def signal_handler(signum, frame):
        quit()

    for sig in (signal.SIGINT, signal.SIGTERM, signal.SIGHUP):
        signal.signal(sig, signal_handler)


def become_daemon():
    # See "Python Standard Library", pg. 29, O'Reilly, for more
    # info on the following.
    pid = os.fork()
    if pid:  # we're the parent if pid is set
        os._exit(0)
    os.setpgrp()
    os.umask(0)

    class DevNull:
        def write(self, message):
            pass

    sys.stdin.close()
    sys.stdout = DevNull()
    sys.stderr = DevNull()


def parse_args():
    working_dir = os.getcwd()

    parser = ArgumentParser(PROG_NAME, add_help=False)
    parser.add_argument('--help', action='help', default=SUPPRESS, help='Show this help message and exit')
    parser.add_argument('-h', '--host', default='localhost', help='SMTP server host')
    parser.add_argument('-p', '--port', default=8025, type=int, help='SMTP server port')
    parser.add_argument('-o', '--output', default=working_dir, help='Save mails to files at given path')
    parser.add_argument('-l', '--log', help='Log to given file')
    parser.add_argument('-O', '--only-log', action='store_true', help='Do not save mails as files')
    parser.add_argument('-b', '--background', action='store_true', help='Run in background')

    args = parser.parse_args()
    if args.background:
        args.log = args.log or os.path.join(os.getcwd(), 'fakemail.log')
    return args


def main():
    global LOG_FILE, ONLY_LOG
    args = parse_args()

    LOG_FILE = args.log
    ONLY_LOG = args.only_log

    handle_signals()
    message(f'Starting {PROG_NAME}')
    if args.background:
        become_daemon()
    try:
        server = FakeServer((args.host, args.port), None, args.output)
    except socket.error as e:
        quit(str(e))
    message('Listening on port %d' % args.port)
    try:
        asyncore.loop()
    except KeyboardInterrupt:
        quit()


if __name__ == '__main__':
    main()
