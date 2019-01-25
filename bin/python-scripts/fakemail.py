#!/Users/bernd/.pyenv/versions/Scripts/bin/python
# Start a SMTP server that catches all emails and saves them to eml files.
# Compatible with python 3.7
import asyncore
import logging
import os
import signal
import smtpd
import socket
import sys
from argparse import ArgumentParser, SUPPRESS

PROG_NAME = 'Fakemail'


class FakeServer(smtpd.SMTPServer):
    RECIPIENT_COUNTER = {}

    def __init__(self, host, port, path, only_log):
        smtpd.SMTPServer.__init__(self, (host, port), None)
        self.logger = logging.getLogger(f'{PROG_NAME}Server')
        self.path = path
        self.only_log = only_log

    def process_message(self, peer, mailfrom, rcpttos, data, **kwargs):
        self.logger.info('Incoming mail')

        for recipient in rcpttos:
            if self.only_log:
                self.logger.info(f'Mail destined for {recipient}')
            else:
                str_data = data.decode('utf-8')

                self.logger.info(f'Capturing mail to {recipient}')
                count = self.RECIPIENT_COUNTER.get(recipient, 0) + 1
                self.RECIPIENT_COUNTER[recipient] = count
                filename = os.path.join(self.path, f'{recipient}.{count}')
                filename = filename.replace('<', '').replace('>', '')
                f = open(filename, 'w')
                f.write(str_data + '\n')
                self.logger.info(str_data)
                f.close()
                self.logger.info(f'Mail to {recipient} saved')
        self.logger.info('Incoming mail dispatched')


class FakeMail:

    def __init__(self, host: str = None, port: int = None, output_dir: str = None, log_file: str = None,
                 only_log: bool = False, background: bool = False):
        self.host = host or 'localhost'
        self.port = port or 8025
        self.output_dir = output_dir
        self.log_file = log_file
        self.only_log = only_log
        self.background = background

        if self.background and not self.log_file:
            self.log_file = os.path.join(os.getcwd(), 'fakemail.log')

        self.configure_logger()
        self.logger = logging.getLogger(PROG_NAME)

        self.server = None

        self.validate_paths()

        signal.signal(signal.SIGINT, self.signal_handler)
        signal.signal(signal.SIGTERM, self.signal_handler)
        signal.signal(signal.SIGHUP, self.signal_handler)

    def start(self):
        self.logger.info(f'Starting {PROG_NAME}')

        if self.background:
            self.become_daemon()
        try:
            self.server = FakeServer(self.host, self.port, self.output_dir, self.only_log)
        except socket.error as e:
            self.quit(str(e))

        self.logger.info(f'Listening on {self.host}:{self.port}')
        try:
            asyncore.loop()
        except KeyboardInterrupt:
            self.quit()

    def quit(self, reason: str = None):
        text = f'Stopping {PROG_NAME}'
        if reason is not None:
            text += f': {reason}'
        self.logger.info(text)
        sys.exit()

    def validate_paths(self):
        def follow_symlinks(path):
            path = os.path.realpath(path)
            if os.path.islink(path):
                return follow_symlinks(path)
            return path

        if not self.output_dir:
            self.output_dir = os.getcwd()
        else:
            self.output_dir = follow_symlinks(self.output_dir)
            if not os.path.isdir(self.output_dir):
                raise NotADirectoryError(f'"{self.output_dir}"" does not exist or is not a directory.')

        if self.log_file:
            self.log_file = follow_symlinks(self.log_file)
            if os.path.isdir(self.log_file):
                self.log_file = os.path.join(self.log_file, 'fakemail.log')
            elif os.path.isfile(self.log_file):
                pass
            else:
                raise FileNotFoundError('Log file could not be found')

    def configure_logger(self):
        handlers = []
        if self.log_file:
            file_handler = logging.FileHandler(self.log_file)
            handlers.append(file_handler)

        if not self.background:
            stream_handler = logging.StreamHandler()
            handlers.append(stream_handler)

        logging.basicConfig(
            level=logging.INFO,
            format='%(asctime)s [%(levelname)s] %(name)s: %(message)s',
            handlers=handlers
        )

    def signal_handler(self, signum, frame):
        self.quit()

    def become_daemon(self):
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

    return parser.parse_args()


if __name__ == '__main__':
    args = parse_args()
    fakemail = FakeMail(args.host, args.port, args.output, args.log, args.only_log, args.background)
    fakemail.start()
