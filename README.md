# binbin

`binbin` is my personal `~/bin` folder and collects a variety of scripts that
are not large enough yet to warrant their own project.

Each file usually comes with a descriptive name, documentation inside the file
and, if you're lucky, a `--help` flag.

## Tools

| Tool | Description |
| --- | --- |
| [`anycite`](bin/anycite) | Generates BibLaTeX entries from URLs, ISBNs, and GitHub repositories. |
| [`boring-shell`](bin/boring-shell) | Opens a minimal Bash environment, mainly for recording screencasts. |
| [`git-autopush`](bin/git-autopush) | Installs a post-commit hook that automatically pushes `master`. |
| [`git-cl`](bin/git-cl) | Clones repositories into a standardized forge/owner/repository hierarchy. |
| [`git-dlist`](bin/git-dlist) | Finds unpushed changes across multiple repositories. |
| [`git-nuke`](bin/git-nuke) | Removes a file from every branch and tag in a Git repository. |
| [`mkusbstick`](bin/mkusbstick) | Formats USB drives for compatibility with Linux, Windows, and macOS. |
| [`pdfmail`](bin/pdfmail) | Downsamples and optionally grayscales PDFs for email. |
| [`shellcolors`](bin/shellcolors) | Prints a terminal color table on different backgrounds. |
| [`syncto`](bin/syncto) | Watches a directory and synchronizes changes to a remote using `rsync`. |
| [`twitch`](bin/twitch) | Plays Twitch streams through `yt-dlp` and `mpv`. |
| [`xsu`](bin/xsu) | Transfers Xauthority credentials before opening a shell as another user. |

## Prerequisites

Most tools are written in Python or shell. The Nix package includes their Python
dependencies; manual installations may need [click](https://click.palletsprojects.com/)
and [requests](https://requests.readthedocs.io/).

## Nix

```nix
inputs.binbin.url = "github:mbr/binbin";
environment.systemPackages = [ inputs.binbin.packages.${pkgs.system}.default ];
```

## Graveyard

- `byzanz-record-window`: Removed because Byzanz was unmaintained.
- `compile-dts`: Removed because its device-tree compilation workflow had bit-rotted.
- `desktop-open`: Removed with the unused desktop application support.
- `docker-run-x11`: Removed in favor of declarative Nix development environments.
- `ghci-color`: Removed because modern GHC provides colored diagnostics.
- `ldtree`: Superseded by [`libtree`](https://github.com/haampie/libtree).
- `pdftoc`: Removed because it was deprecated and unused.
- `pgdb.sh`: Superseded by the dedicated
  [`pgdb`](https://github.com/mbr/pgdb-rs) tool.
- `ppatool`: Removed because it was deprecated and unused.
- `repl`: Moved to the dedicated [`repl`](https://github.com/mbr/repl) repository.
- `rerun`: Superseded by [`watchexec`](https://watchexec.github.io/).
- `sstoggle`: Removed because its XScreenSaver-based implementation was unmaintained.
- `tpl`: Removed because it was deprecated and unused.
- `wrimg`: Moved to the dedicated [`wrimg`](https://github.com/mbr/wrimg) repository.
- `xdg-gmail`: Removed because the Chrome-based Gmail launcher was unused.
