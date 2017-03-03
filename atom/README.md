My Atom config files. These should be copied to `~/.atom/`.

`../makelinks.sh` will do this for you if you run:

```bash
# Clone the repo.
git clone https://github.com/cjwelborn/dotfiles
# Make sure you're in the dotfile root directory.
cd dotfiles
# Let `makelinks` copy these to ~/.atom.
# --force may be needed to remove the default config files!
./makelinks.sh atom/*
```
