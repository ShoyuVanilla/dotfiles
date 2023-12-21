import json
import os
from pathlib import Path
import platform
import subprocess
import sys

def mergedicts(dict1, dict2):
    for k in set(dict1.keys()).union(dict2.keys()):
        if k in dict1 and k in dict2:
            if isinstance(dict1[k], dict) and isinstance(dict2[k], dict):
                yield (k, dict(mergedicts(dict1[k], dict2[k])))
            else:
                yield (k, dict2[k])
        elif k in dict1:
            yield (k, dict1[k])
        else:
            yield (k, dict2[k])

def apply_settings(src_path, dest_path, platform_name):
    common = json.load(open(src_path.joinpath('settings.common.json')))
    platform_name = json.load(open(src_path.joinpath('settings.{}.json'.format(platform_name))))
    src = dict(mergedicts(common, platform_name))
    dest = dest_path.joinpath('settings.json')
    json.dump(src, open(dest, 'w'), indent=2, sort_keys=True)

def apply_keybindings(src_path, dest_path, platform_name):
    print(src_path)
    print(dest_path)

def install_extensions(src_path, remove_undefined):
    extensions_local = set(
        subprocess
            .check_output(['code', '--list-extensions'])
            .decode('utf-8') # Need to check if valid on Windows
            .splitlines()
    )
    extensions_defined = src_path.joinpath('extensions')
    extensions_defined = set(open(extensions_defined, 'r').read().splitlines())
    to_install = extensions_defined - extensions_local
    for extension in to_install:
        os.system('code --install-extension {}'.format(extension))

    if remove_undefined:
        to_remove = extensions_local - extensions_defined
        for extension in to_remove:
            os.system('code --uninstall-extension {}'.format(extension))

def main():
    script_path = Path(__file__)
    src_path = script_path.parent.parent.joinpath('vs-code')
    platform_name = platform.system()

    dest_path = None
    if platform_name.startswith('Windows'):
        dest_path = (
            Path(os.getenv('APPDATA'))
                .joinpath('Code')
                .joinpath('User')
        )
        platform_name = 'windows'
    elif platform_name.startswith('Darwin'):
        dest_path = (
            Path(os.getenv('HOME'))
                .joinpath('Library')
                .joinpath('Application Support')
                .joinpath('Code')
                .joinpath('User')
        )
        platform_name = 'macos'
    elif platform_name.startswith('Linux'):
        dest_path = (
            Path(os.getenv('HOME'))
                .joinpath('.config')
                .joinpath('Code')
                .joinpath('User')
        )
        platform_name = 'linux'
    else:
        sys.exit('Unknown Platform: {}', platform_name)

    # install_extensions(src_path, True)
    apply_settings(src_path, dest_path, platform_name)
    apply_keybindings(src_path, dest_path, platform_name)

if __name__ == '__main__':
    main()
