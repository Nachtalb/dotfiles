#!/Users/bernd/.pyenv/versions/py3-scripts/bin/python
# Run bin/instance dynamically on an available port
#
# When the default port in the parts/instance/etc/zope.conf already in use, it
# checks what the next available (starting with 8080) port to use is. If the
# site is already running on a port, it tells you so. In this case it gives you
# a link to the running instance and the PID, so you can kill it more easily if
# you which to do so. Only ports starting with 80 are evaluated.
import logging
import os
import re
import shutil
import signal
import sys
from subprocess import check_output

import psutil


class Unbuffered(object):
    def __init__(self, stream):
        self.stream = stream

    def write(self, data):
        self.stream.write(data)
        self.stream.flush()

    def writelines(self, datas):
        self.stream.writelines(datas)
        self.stream.flush()

    def __getattr__(self, attr):
        return getattr(self.stream, attr)


# https://stackoverflow.com/a/107717/5699307
sys.stdout = Unbuffered(sys.stdout)

logging.basicConfig(stream=sys.stdout, level=logging.INFO, format='%(levelname)s: %(message)s')
logger = logging.getLogger()

WORKING_DIR = os.getcwd()
ZOPE_CONF_PATH = os.path.join(WORKING_DIR, 'parts/instance/etc/zope.conf')
INSTANCE_PATH = os.path.join(WORKING_DIR, 'bin/instance')

DEFAULT_INSTANCE_PORT = 8080
RUNNING = False

ZOPE_CONF_ADDRESS_REGEX = re.compile('<http-server>.*\n\s*((address)\s(.*))\n</http-server>')
ZOPE_CONF_ADDRESS_TEMPLATE = '<http-server>\n  address {port}\n</http-server>'

KILL_OTHERS = False


def yes_no_input_dialog(question, default=True):
    no = ['no', 'n']
    yes = ['yes', 'y']
    yes_default, no_default = 'Y', 'n'
    if not default:
        yes_default, no_default = 'y', 'N'

    answer = None
    while answer is None:
        user_input = input(f'{question} [{yes_default}/{no_default}]').lower()

        if not user_input:
            answer = default
            break
        elif user_input in no + yes:
            answer = True if user_input in yes else False

    return answer


def check_path(path, name=None, exit_on_error=True):
    global logger
    name = name or 'Path'
    if not os.path.isfile(path):
        logger.fatal(f'{name} does not exit: {path}')
        if exit_on_error:
            sys.exit(1)


def local_running_ports():
    netstat_processes = check_output('netstat -vanp tcp | grep -E "\*\.80\d\d.*LISTEN" | cut -d. -f2,3', shell=True)

    port_regex = re.compile('^(\d\d\d\d)')
    pid_regex = re.compile('(\d*)\s+\d\s*$')

    ports_pid_tuples = []
    for line in netstat_processes.decode('ascii').split('\n'):
        if not line:
            continue

        port_result = port_regex.search(line)
        if not port_result or not port_result.groups():
            continue
        port = int(port_result.groups()[0])

        pid_result = pid_regex.search(line)
        if not pid_result or not pid_result.groups():
            continue
        pid = int(pid_result.groups()[0])

        ports_pid_tuples.append((port, pid))

    ports_pid_tuples = sorted(ports_pid_tuples, key=lambda item: item[0])
    return ports_pid_tuples


def get_port_from_zope_conf():
    with open(ZOPE_CONF_PATH, mode='r') as zope_file:
        content = zope_file.read()
        result = ZOPE_CONF_ADDRESS_REGEX.search(content)

        if not result:
            print(f'Zope Confg has no port defined {ZOPE_CONF_PATH}')
            sys.exit(1)

        port = result.groups()[-1]
        port = re.sub('\D', '', port)
        if not port:
            print(f'Zope Config has no valid port defined {ZOPE_CONF_PATH}')
            sys.exit(1)

        return int(port)


def get_process_of_current_script_running(process):
    if __file__ in process.cmdline():
        return process

    if process.name() in ['kernel_task']:  # ToDo add breakpoint for linux
        return False
    else:
        return get_process_of_current_script_running(process.parent())


def check_running_ports():
    global KILL_OTHERS
    ports_pid_tuples = local_running_ports()

    for port, pid in ports_pid_tuples:
        process = psutil.Process(pid)
        if process.cwd() == WORKING_DIR:
            logger.warning(f'Current instance already running: PID={pid} URL=http://localhost:{port}')
            if KILL_OTHERS or yes_no_input_dialog('Should the instance be killed?'):
                if KILL_OTHERS:
                    logger.warning(f'Instance PID={pid} will be automatically killed due to --autokill')

                try:
                    process_to_kill = get_process_of_current_script_running(process)
                    if not process_to_kill:
                        process_to_kill = process

                    for child in process_to_kill.children(recursive=True):
                        child.terminate()

                    process_to_kill.wait()
                    process_to_kill.terminate()
                except (psutil.NoSuchProcess, psutil.AccessDenied):
                    # Process has already finished after bin/instance was terminated
                    logger.warning(f'Tried to kill process PID={pid} but could not do it. Maybe the process was '
                                   f'already stopped in the meantime.')
                    if KILL_OTHERS:
                        logger.warning('We still try to start it up again. Due to Autokill mode.')
                    pass
            else:
                sys.exit(0)


def get_working_port(default_port):
    ports_pid_tuples = local_running_ports()
    ports = [tuple_[0] for tuple_ in ports_pid_tuples]

    instance_port = default_port or get_port_from_zope_conf()

    if instance_port not in ports:
        return instance_port
    elif 8080 not in ports:
        return 8080

    for port in ports:
        if (port + 1) not in ports:
            return port + 1
    logger.fatal('Something went wrong while getting a new port')
    sys.exit(1)


def replace_zope_conf_port(new_port):
    backup_file = ZOPE_CONF_PATH + '.bak'
    shutil.copy(ZOPE_CONF_PATH, backup_file)

    try:
        with open(ZOPE_CONF_PATH, mode='r+') as zope_file:
            content = zope_file.read()
            zope_file.seek(0)
            result = ZOPE_CONF_ADDRESS_REGEX.search(content)

            if not result:
                raise ValueError('no port')
            old_port = result.groups()[-1]
            try:
                content = ZOPE_CONF_ADDRESS_REGEX.sub(ZOPE_CONF_ADDRESS_TEMPLATE.format(port=new_port), content)
                zope_file.write(content)
                logger.info(f'Setting port in {ZOPE_CONF_PATH} from {old_port} to {new_port}')
            except ValueError:
                raise ValueError('no port')
    except (Exception, BaseException) as e:
        if hasattr(e, 'args') and 'no port' in e.args:
            print(f'No valid port defined in zope conf file: "{ZOPE_CONF_PATH}"')
        shutil.copy(backup_file, ZOPE_CONF_PATH)
        raise e


def exit_gracefully(*args, **kwargs):
    global RUNNING, DEFAULT_INSTANCE_PORT
    if RUNNING:
        RUNNING = False
    else:
        return

    logger.info(f'\nExiting ...')
    replace_zope_conf_port(DEFAULT_INSTANCE_PORT)


def main():
    global RUNNING, DEFAULT_INSTANCE_PORT, KILL_OTHERS
    if '--help' in sys.argv or '-h' in sys.argv:
        print('instance --autokill / -a\n'
              '--autokill / -a\tkills other instances automatically without asking first.')
        return
    if '--autokill' in sys.argv or '-a' in sys.argv:
        KILL_OTHERS = True
        logger.warning('Autokill set to true')

    logger.info(f'Working dir: {WORKING_DIR}')

    check_path(ZOPE_CONF_PATH, 'Zope config')
    check_path(INSTANCE_PATH, 'Instance script')

    check_running_ports()

    DEFAULT_INSTANCE_PORT = get_port_from_zope_conf()
    used_port = get_working_port(DEFAULT_INSTANCE_PORT)

    replace_zope_conf_port(used_port)

    message = f'Using {used_port}: http://localhost:{used_port}/'
    logger.info(message)
    logger.info('-' * len(message) + '\n\n')

    signal.signal(signal.SIGINT, exit_gracefully)
    signal.signal(signal.SIGTERM, exit_gracefully)

    RUNNING = True
    os.system(f'{INSTANCE_PATH} fg')


if __name__ == '__main__':
    try:
        main()
    except Exception as e:
        exit_gracefully()
        raise e
