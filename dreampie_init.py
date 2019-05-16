#!/usr/bin/env python3

""" dreampie_init.py
    Imported in `.dreampie`, to initialize the environment.
    Moved to this separate file so I can easily use linting/highlighting
    when editing it. It used to live in `.dreampie` itself, but was replaced
    with a simple import of this script.
    -Christopher Welborn 05-16-2019
"""

# Code is cleverfied so I only have to update the import list,
# nothing else.
import os
import site
import sys

# Removed after init.
import textwrap

# Fix weird dreampie sys.path bug.
sitelocal = site.getusersitepackages()
if os.path.exists(sitelocal) and (sitelocal not in sys.path):
    sys.path.insert(0, sitelocal)
    print('Added user site dir:\n  {}'.format(sitelocal))


# Another weird dreampie sys.path bug.
for siteglobal in site.getsitepackages():
    if os.path.exists(siteglobal) and (siteglobal not in sys.path):
        sys.path.append(siteglobal)
        print('Added site dir:\n  {}'.format(siteglobal))

sys.path = list(sorted(set(sys.path)))
# This is supposed to be done automatically,
# but DreamPie somehow messes this up.
print('Reloading import machinery.')
site.main()

autoimports = (
    'datetime.datetime',
    'datetime.timedelta',
    'json',
    'importlib',
    'inspect',
    'os',
    'platform',
    're',
    'subprocess',
    'sys',
    'time',
    'tkinter-Tkinter',
    'tkinter.ttk-none',
)


def add_import_path(path=None):
    """ Add a path to sys.path. """
    scriptdir = '/home/cj/scripts'
    path = os.path.join(scriptdir, path) if path else scriptdir
    sys.path.insert(1, path)
    sys.stdout.write('\nNew import path: {}\n'.format(path))


def compile_file(filename):
    """ Execute a script in the global scope. """
    with open(filename, 'r') as f:
        return compile(f.read(), filename, 'exec')


def compile_script(filename):
    if os.path.exists(filename):
        return compile_file(filename)
    scriptdir = os.path.join('/home/cj/scripts', filename)
    if os.path.exists(scriptdir):
        return compile_file(scriptdir)
    raise FileNotFoundError('Cannot find this file:\n  {}'.format(filename))


def edit_file(filename, vim=False):
    """ Open a file with `subl`. """
    filename = filename.strip()
    if not (filename and os.path.exists(filename)):
        print('\nFile does not exist:\n  {}'.format(filename), file=sys.stderr)
        return None

    if vim:
        cmd = ['konsole', '-e', 'vim']
    else:
        cmd = ['subl']
    cmd.append(filename)
    return run_command(cmd, background=True)


def formatblk(text, width=45, prepend=None):
    return textwrap.indent(
        '\n'.join(textwrap.wrap(text, width=width)),
        '    ' if prepend is None else prepend,
    )


def import_modnames(autos, globs, locs):
    sys.stdout.write('Imported:\n')
    imported = []
    for i, modnames in enumerate(autos):
        versions = modnames.split('-')
        if (len(versions) == 1) or (sys.version_info.major > 2):
            modname = versions[0]
        elif sys.version_info.major < 3:
            modname = versions[1]
        if modname.lower() == 'none':
            sys.stdout.write(
                '\nSkipping import for Python 2.7: {}\n'.format(
                    versions[0]
                )
            )
            continue
        root, _, subs = modname.partition('.')
        if subs:
            exec('from {} import {}'.format(root, subs), globs, locs)
        else:
            exec('import {}'.format(modname), globs, locs)

        imported.append(modname)
    print(formatblk(', '.join(imported), width=45, prepend='    '))


def import_script(path):
    """ Import a module from my ~/scripts directory. """
    modpath, filename = os.path.split(path)
    modname = os.path.splitext(filename)[0]
    add_import_path(modpath)
    try:
        modl = importlib.import_module(modname)  # noqa (implicitly imported)
    except ImportError as ex:
        sys.stderr.write('\nFailed to import `{}`:\n  {}\n'.format(modname, ex))
    else:
        globals()[modname] = modl
        sys.stdout.write('\nImported module:\n  {}\n'.format(modname))


def list_global_funcs(ignore=None):
    from types import FunctionType
    ignored = ignore or []
    print('\nGlobal Classes/Functions:')
    globs = globals()
    globfuncs = [
        k
        for k in sorted(globs)
        if isinstance(globs[k], (type, FunctionType)) and
        k not in ignored
    ]
    print(formatblk(', '.join(globfuncs), width=45, prepend='    '))


def run_command(*args, background=False, **kwargs):
    """ Shortcut to subprocess.check_output(). """
    print('\nRunning: {}\n'.format(' '.join(args)))
    if background:
        # Command may open a new konsole or window. It needs to stay alive.
        return subprocess.Popen(args, **kwargs)  # noqa (implicitly imported)

    # Checking output for a simple command.
    if kwargs.get('stderr', None) is None:
        kwargs['stderr'] = subprocess.STDOUT  # noqa (implicitly imported)
    output = subprocess.check_output(  # noqa (implicitly imported)
        args,
        **kwargs,
    )
    if hasattr(output, 'decode'):
        output = output.decode()
    return output


def run_script(filename, *args, exe=None, p=False, print_output=False):
    """ Run a bash or python script. """
    scriptsdir = '/home/cj/scripts'
    _, fname = os.path.split(filename)[-1]
    basename, _ = os.path.splitext(fname)[0]
    trypaths = (
        filename,
        '{}.py'.format(filename),
        '{}.sh'.format(filename),
        os.path.join(scriptsdir, filename),
        os.path.join(scriptsdir, '{}.py'.format(filename)),
        os.path.join(scriptsdir, '{}.sh'.format(filename)),
        os.path.join(scriptsdir, basename, '{}.py'.format(filename)),
        os.path.join(scriptsdir, basename, '{}.sh'.format(filename)),
        os.path.join(scriptsdir, 'bash', filename),
        os.path.join(scriptsdir, 'bash', '{}.sh'.format(filename)),
        os.path.join(scriptsdir, 'bash', basename, filename),
        os.path.join(scriptsdir, 'bash', basename, '{}.sh'.format(filename)),
    )
    for trypath in trypaths:
        if os.path.exists(trypath):
            scriptfile = trypath
            break
    else:
        print('File not found: {}'.format(filename), file=sys.stderr)
        return None
    if exe:
        cmd = [exe, scriptfile]
    elif scriptfile.endswith(('.sh', '.bash')):
        cmd = ['bash', scriptfile]
    elif scriptfile.endswith(('.py', '.pyw')):
        cmd = ['python3', scriptfile]
    else:
        print(
            'Unknown file type: {}'.format(os.path.split(scriptfile)[-1]),
            file=sys.stderr,
        )
        print(
            'Add a case/command for it in dreampie_init.py:run_script().',
            file=sys.stderr,
        )
        return None
    cmd.extend(args)
    output = run_command(cmd)
    if p or print_output:
        print(output)
    return output


# Globals that will persist
RAGE = lambda : sys.stdout.write('\n\n\n(╯°□°)╯︵┻━┻\n\n')  # noqa

import_modnames(autoimports, globals(), locals())

get_src_file = inspect.getsourcefile  # noqa (implicitly imported)

# Aliases
try:
    tk = tkinter
except NameError:
    tk = Tkinter  # noqa (undefined name)
try:
    ttk = tkinter.ttk
except NameError:
    sys.stdout.write('ttk not available in python 2.7.\n')

# List global functions.
list_global_funcs(ignore=('list_global_funcs', ))

# Globals to remove.
if __name__ == 'dreampie_init':
    # Module was imported into dreampie, or somewhere else.
    del textwrap
    del autoimports
    del import_modnames
    del list_global_funcs