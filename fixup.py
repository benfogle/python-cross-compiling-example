# Run with build-python

import subprocess
import os
import sys
import stat
import logging

logger = logging.getLogger(__name__)

def fixup_elf(path):
    dirname = os.path.dirname(path)
    rpath = os.path.relpath(LIBDIR, dirname)
    rpath = os.path.join('$ORIGIN', rpath)
    logger.info("Patching ELF %s RPATH=%s", path, rpath)
    subprocess.Popen([STRIP, path]).wait()
    subprocess.Popen(['patchelf', '--set-rpath', rpath, path]).wait()

def fixup_script(path):
    with open(path, 'rb') as fp:
        shebang = fp.readline()
        interp = shebang[2:].split(None,1)
        base = os.path.basename(interp[0])
        if interp[0] == b'/bin/sh':
            interp[0] = b'/system/bin/sh'
        elif base.startswith(b'python'):
            interp[0] = b'/system/bin/env ' + base
        else:
            return # no change
        remainder = fp.read()
    with open(path, 'wb') as fp:
        fp.write(b'#!' + b' '.join(interp) + b'\n')
        fp.write(remainder)
    logger.info("Patching script %s (interp=%s)", path, interp[0])

def fixup(path):
    with open(path, 'rb') as fp:
        magic = fp.read(4)
        if magic == b'\x7fELF':
            return fixup_elf(path)
        elif magic.startswith(b'#!'):
            return fixup_script(path)

def is_file(path):
    return stat.S_ISREG(os.lstat(path).st_mode)

def fix_all(install):
    for root, dirs, files in os.walk(install):
        for f in files:
            path = os.path.join(root, f)
            if is_file(path):
                fixup(path)

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print("Usage: %s <install-dir> <strip>" % sys.argv[0])
        sys.exit(1)

    logging.basicConfig(level=logging.INFO)
    INSTALL = sys.argv[1]
    LIBDIR = os.path.join(INSTALL, 'lib')
    STRIP = sys.argv[2]
    fix_all(INSTALL)
