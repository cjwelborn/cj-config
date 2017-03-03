Just some config files that make any machine feel like home.

This repo must be cloned with `git clone --recursive` so that all `vim`
plugins are installed to `./.vim`.

`./makelinks.sh` can be used to create symlinks to all of the files. It tries
to be smart about it and not clobber anything (unless `--force` is used). You can do a `--dryrun` to see what will happen without changing anything. It will accept file paths as arguments to symlink only *some* of the files.


Current files (<small>if I remember to update this readme</small>):

File | Description
--- | ---
`.vim` | My `vim` config, with all plugins called from `.vimrc`.
`atom` | Atom init file, key-bindings, project list, and config.
`sublime-text` | Custom Sublime Text commands, key-bindings, and preferences.
`.agignore` | Global ignore file for the `ag` command.
`.dir_colors` | Directory/file colors for `ls`, which is referenced from [dotfiles/bash.extras.interactive.sh](https://github.com/cjwelborn/dotfiles/blob/dev/bash.extras.interactive.sh#L61).
`.dreampie` | Config for [DreamPie](http://www.dreampie.org/) Python REPL, with custom Solarized Dark theme and init script.
`.eslintrc.json` | Global config for `eslint`.
`.face` | Login avatar for KDE.
`.gitconfig` | Global git config for aliases.
`.green` | Global config for `green`, a python test runner.
`.lessfilter` | Custom script that allows `less` to highlight source files, or handle "unknown" file formats. It currently uses [ccat](https://github.com/welbornprod/ccat) to highlight source files.
`.pystartup` | Python startup file for interactive use. It imports some stuff, and highlights tracebacks using pygments.
`.scss-lint.yml` | Global config for `scss-lint`.
`.vimrc` | Config for `vim` with key-bindings and plugins from `.vim`.
`.Xresources` | Xterm config file, for when I have to use it.
`makelinks.sh` | A script to symlink all of these files where they belong.
