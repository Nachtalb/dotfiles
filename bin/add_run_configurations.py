#!/Users/bernd/.pyenv/versions/Scripts/bin/python
# Adds various Plone related run configurations to to a Jetbrains Project.
#
# usage: add_run_configurations.py [-h] path [name]
#
# Add run configuration to project
#
# positional arguments:
#   path        Path to project
#   name        Project Name
#
# optional arguments:
#   -h, --help  show this help message and exit

import argparse
import os
import xml.etree.ElementTree as ET

BASE_PATH = os.path.abspath(os.path.dirname(os.path.realpath(__file__)))


def yes_no_repeat(string, default=True, show_help=False, additional_options=None):
    additional_options = additional_options or {}
    yes_no = ['Y', 'n'] if default else ['y', 'N']
    yes_no_str = '/'.join(yes_no + list(additional_options))

    help_string = 'y = Yes | n = No'
    for short, options in additional_options.items():
        if 'help' in options:
            help_string += f' | {short.lower()} = {options["help"]}'

    if show_help:
        print(help_string)

    while True:
        answer = input(f'{string} [{yes_no_str}]: ').lower()
        for short, options in additional_options.items():
            if answer in list(map(str.lower, options['accept'])):
                return options['value']

        if answer in ['yes', 'y']:
            return True
        elif answer in ['no', 'n']:
            return False
        elif answer == '':
            return default


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Add run configuration to project')
    parser.add_argument('path', help='Path to project')
    parser.add_argument('name', help='Project Name', nargs='?')

    args = parser.parse_args()

    project_path = os.path.realpath(args.path.strip())
    workspace_path = os.path.join(project_path, '.idea', 'workspace.xml')
    project_name = args.name or os.path.basename(project_path)

    if not os.path.isfile(workspace_path):
        FileNotFoundError(f'Make sure it is a Jetbrains Project, "{workspace_path}" not found.')
        exit(1)

    if not yes_no_repeat(f'Is this the correct project name "{project_name}"'):
        project_name = input('Then give me the correct one: ')

    print(f'Project name: "{project_name}"\nProject Path "{project_path}"\nConfiguration Path "{workspace_path}"')

    workspace_tree = ET.parse(workspace_path)
    workspace_root = workspace_tree.getroot()
    workspace_run_manager = workspace_tree.find('./component[@name=\'RunManager\']')

    with open(os.path.join(BASE_PATH, 'run_manager.xml'), 'r') as run_manager_file:
        run_manager_content = run_manager_file.read()

    upgrade_path = '/'.join(project_name.split('.'))

    run_manager_content = run_manager_content.replace('{{UPGRADE_PATH}}', upgrade_path)
    run_manager_content = run_manager_content.replace('{{PROJECT_NAME}}', project_name)
    new_run_manager_root = ET.fromstring(run_manager_content)
    new_configurations = list(new_run_manager_root)

    if not workspace_run_manager:
        workspace_root.append(new_run_manager_root)
        print('Copied configurations over')
    else:
        replace_all = None
        replace_none = None
        for configuration in new_configurations:
            if configuration.tag != 'configuration':
                continue

            name = configuration.attrib['name']
            if workspace_run_manager:
                existing = workspace_run_manager.find(f'configuration[@name=\'{name}\']')

                if not replace_none and existing:
                    answer = False
                    if replace_all is None and replace_none is None:
                        answer = yes_no_repeat(f'Replace configuration "{name}"?', show_help=True, additional_options={
                            'r': {
                                'accept': ['replace', 'r', 'replace remaining'],
                                'value': 1,
                                'help': 'Replace remaining',
                            },
                            's': {
                                'accept': ['skip', 's', 'skip remaining'],
                                'value': -1,
                                'help': 'Skip remaining',
                            },
                        })
                        if answer is 1:
                            replace_all = True
                            answer = True
                        elif answer is -1:
                            replace_none = True
                            continue
                    elif not replace_all:
                        answer = yes_no_repeat(f'Replace configuration "{name}"?')

                    if replace_all or answer:
                        workspace_run_manager.remove(existing)
                    else:
                        continue
            workspace_run_manager.append(configuration)
            print(f'New configuration added: "{name}"')

        new_configuration_list = ET.Element('list')
        for configuration in workspace_run_manager.findall('configuration'):
            item = ET.SubElement(new_configuration_list, 'item')
            item.set('itemvalue', configuration.attrib['name'])

        old_configuration_list = workspace_run_manager.find('list')
        if old_configuration_list:
            workspace_run_manager.remove(old_configuration_list)
        workspace_run_manager.append(new_configuration_list)

    workspace_tree.write(workspace_path)
    print('Done')
