import os
import platform
import subprocess
import sys
from pathlib import Path

def apply_settings(src_path, dest_path):
    print(src_path)
    print(dest_path)

def apply_keybindings(src_path, dest_path):
    print(src_path)
    print(dest_path)

def sync_extensions(src_path, remove_undefined):
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
    os_name = platform.system()

    dest_path = None
    if os_name.startswith('Windows'):
        dest_path = (
            Path(os.getenv('APPDATA'))
                .joinpath('Code')
                .joinpath('User')
        )
    elif os_name.startswith('Darwin'):
        dest_path = (
            Path(os.getenv('HOME'))
                .joinpath('Library')
                .joinpath('Application Support')
                .joinpath('Code')
                .joinpath('User')
        )
    elif os_name.startswith('Linux'):
        dest_path = (
            Path(os.getenv('HOME'))
                .joinpath('.config')
                .joinpath('Code')
                .joinpath('User')
        )
    else:
        sys.exit('Unsupported Platform: {}', os_name)

    sync_extensions(src_path, True)
    apply_settings(src_path, dest_path)
    apply_keybindings(src_path, dest_path)

if __name__ == '__main__':
    main()
