#!/home/bernd/.pyenv/versions/3.9.4/bin/python
from pathlib import Path
from zipfile import ZipFile
import json
import sys
import pygraphviz as pgv


folder = Path()
if len(sys.argv) == 2:
    out = Path(sys.argv[1])
elif len(sys.argv) > 2:
    out = Path(sys.argv[1])
    folder = Path(sys.argv[2])
else:
    print('You have to define a output path')
    sys.exit(1)


def url(info):
    if isinstance(info, dict):
        if url := info.get('contact', {}).get('homepage'):
            return url
        info = info['id']
    return f'https://www.curseforge.com/minecraft/mc-mods/{info.replace("_", "-")}'


def get_mod_info(file, parent=''):
    with ZipFile(file, 'r') as zipfile:
        try:
            mod_info = json.loads(zipfile.open('fabric.mod.json').read().decode('utf-8').replace('\n', ''))
            if parent:
                mod_info['is_child'] = True
            yield mod_info
        except Exception as e:
            print(f'{parent or file}:\t Error parsing mod json {e}')
            return

        for jar in filter(None, map(lambda j: j.get('file'), mod_info.get('jars', []))):
            yield from get_mod_info(zipfile.open(jar), parent + '/' + mod_info['id'])


g = pgv.AGraph(directed=True, strict=True, rankdir='TB')
for file in folder.glob('*.jar'):
    for mod_info in get_mod_info(file):
        id = mod_info['id']
        deps = [m for m in mod_info.get('depends',    {}).keys() if m not in ['minecraft', 'fabric', 'fabricloader', 'java', 'fabric-api-base']]
        recs = [m for m in mod_info.get('recommends', {}).keys() if m not in ['minecraft', 'fabric', 'fabricloader', 'java', 'fabric-api-base']]
        sugs = [m for m in mod_info.get('suggests',   {}).keys() if m not in ['minecraft', 'fabric', 'fabricloader', 'java', 'fabric-api-base']]
        try:
            node = pgv.Node(g, id)
            versions = (node.attr.get('versions') or '').split('\n') + [mod_info['version']]
        except KeyError:
            node = None
            versions = [mod_info['version']]

        kw = {
            'versions': '\n'.join(set(versions)),
            'URL': url(mod_info),
            'n': id,
            'color': 'green' if mod_info.get('is_child') else 'blue',
        }
        g.add_node(**kw)

        for dep in deps:
            if dep not in g.nodes():
                g.add_node(dep, color='red', URL=url(dep))
            g.add_edge(id, dep)
        for rec in recs:
            if rec not in g.nodes():
                g.add_node(rec, color='orange', URL=url(rec))
            g.add_edge(id, rec, color='green')
        for sug in sugs:
            if sug not in g.nodes():
                g.add_node(sug, color='violet', URL=url(sug))
            g.add_edge(id, sug, color='violet')
# g.remove_node = lambda x: x
for node in g.nodes():
    if node.attr.get('color') == 'green':
        g.remove_node(node)
for node in g.nodes():
    if not g.neighbors(node):
        g.remove_node(node)
for node in g.nodes():
    if node.attr.get('color') != 'blue':
        continue
    for neigh in g.neighbors(node):
        if neigh.attr.get('color') != 'blue':
            break
    else:
        g.remove_node(node)
g.draw(out, prog='fdp')
