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


def yes_no_repeat(string, default=True):
    ok_answer = None
    yes_no_str = 'Y/n' if default else 'y/N'
    while ok_answer is None:
        answer = input(f'{string} [{yes_no_str}]: ').lower()
        if answer in ['yes', 'y']:
            ok_answer = True
        elif answer in ['no', 'n']:
            ok_answer = False
        elif answer == '':
            ok_answer = default
    return ok_answer


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
        for configuration in new_configurations:
            if configuration.tag != 'configuration':
                continue

            name = configuration.attrib['name']
            if workspace_run_manager:
                existing = workspace_run_manager.find(f'configuration[@name=\'{name}\']')

                if existing:
                    if yes_no_repeat(f'Replace configuration "{name}"?'):
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
