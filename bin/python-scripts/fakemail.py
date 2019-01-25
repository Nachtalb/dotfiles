#!/Users/bernd/.pyenv/versions/Scripts/bin/python
#
# fakemail (Python version)
#
# Compatible with python 3.7


import asyncore
import getopt
import os
import signal
import smtpd
import socket
import sys


class FakeServer(smtpd.SMTPServer):
    RECIPIENT_COUNTER = {}

    def __init__(self, localaddr, remoteaddr, path):
        smtpd.SMTPServer.__init__(self, localaddr, remoteaddr)
        self.path = path

    def process_message(self, peer, mailfrom, rcpttos, data, **kwargs):
        message("Incoming mail")

        for recipient in rcpttos:
            if onlylog:
                message("Mail destined for %s" % recipient)
            else:
                str_data = data.decode('utf-8')

                message("Capturing mail to %s" % recipient)
                count = self.RECIPIENT_COUNTER.get(recipient, 0) + 1
                self.RECIPIENT_COUNTER[recipient] = count
                filename = os.path.join(self.path, "%s.%s" % (recipient, count))
                filename = filename.replace("<", "").replace(">", "")
                f = open(filename, "w")
                f.write(str_data + '\n')
                print(str_data)
                f.close()
                message("Mail to %s saved" % recipient)
        message("Incoming mail dispatched")


def usage():
    print("Usage: %s [OPTIONS]" % os.path.basename(sys.argv[0]))
    print("""
OPTIONS
        --host=<localdomain>
        --port=<port number>
        --path=<path to save mails>
        --log=<optional file to append messages to>
        --onlylog
        --background""")


def quit(reason=None):
    global progname
    text = "Stopping %s" % progname
    if reason is not None:
        text += ": %s" % reason
    message(text)
    sys.exit()


log_file = None
onlylog = False


def message(text):
    global log_file
    if log_file is not None:
        f = open(log_file, "a")
        f.write(text + "\n")
        f.close()

    if not (log_file and onlylog):
        print(text)


def handle_signals():
    def signal_handler(signum, frame):
        quit()

    for sig in (signal.SIGINT, signal.SIGTERM, signal.SIGHUP):
        signal.signal(sig, signal_handler)


def read_command_line():
    global log_file, onlylog
    try:
        optlist, args = getopt.getopt(sys.argv[1:], "",
                                      ["host=", "port=", "path=", "log=",
                                       "onlylog", "background"])
    except getopt.GetoptError:
        usage()
        sys.exit(2)
    # Set defaults
    host = "localhost"
    port = 8025
    path = os.getcwd()
    background = False
    for opt, arg in optlist:
        if opt == "--host":
            host = arg
        elif opt == "--port":
            port = int(arg)
        elif opt == "--path":
            path = arg
        elif opt == "--log":
            log_file = arg
        elif opt == "--onlylog":
            onlylog = True
        elif opt == "--background":
            background = True
    return host, port, path, background


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


def main():
    global progname
    handle_signals()
    host, port, path, background = read_command_line()
    message("Starting %s" % progname)
    if background:
        become_daemon()
    try:
        server = FakeServer((host, port), None, path)
    except socket.error as e:
        quit(str(e))
    message("Listening on port %d" % port)
    try:
        asyncore.loop()
    except KeyboardInterrupt:
        quit()


if __name__ == "__main__":
    progname = os.path.basename(sys.argv[0])
    main()
