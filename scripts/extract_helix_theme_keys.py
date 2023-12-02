import json
import re
import sys

class Node:
    def __init__(self):
        self.keys = []
        self.desc = ''
        self.children = []

def add_key_recurse(acc, prefix: str, node: Node):
    for key in node.keys:
        full_key = key
        if len(prefix) > 0:
            full_key = '.'.join([prefix, key]) 
        acc[full_key] = node.desc.strip()
        for child in node.children:
            add_key_recurse(acc, full_key, child)

list_pattern = re.compile(r'^([ ]*)- ((`[^`]+`,[ ]?)*(`[^`]+`))(.*)$')
table_pattern = re.compile(r'^\|[ ]*`([^`]+)`[ ]*\|([^|]*)\|\s*$')

def extract_keys(src):
    nodes = []
    context = []
    depth = 0
    dic = {}

    for line in src:
        matches = list(list_pattern.finditer(line))
        if len(matches) == 0:
            match = table_pattern.fullmatch(line)
            if match is None:
                continue
            key, desc = match.groups()
            dic[key] = desc.strip()
            continue
        match = matches[-1]
        indent, keys, _, _, desc = match.groups()
        keys = keys.replace('`', '').replace(' ', '').split(',')
        indent = len(str(indent or '')) // 2
        node = Node()
        node.keys = keys
        node.desc = desc
        if indent > depth:
            depth += 1
        else:
            strip = 1 + depth - indent
            context = context[:-strip]
            depth = indent
        if len(context) == 0:
            nodes.append(node)
        else:
            context[-1].children.append(node)
        context.append(node)

    for node in nodes:
        add_key_recurse(dic, '', node)
    print(json.dumps(dic, indent=2))

def main():
    extract_keys(sys.stdin)

if __name__ == "__main__":
    main()
