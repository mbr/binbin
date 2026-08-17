# binbin

`binbin` is my personal `~/bin` folder and collects a variety of scripts that
are not large enough yet to warrant their own project.

Each file usually comes with a descriptive name, documentation inside the file
and, if you're lucky, a `--help` flag.

## Prerequisites

Most tools are self-containted and written in either Python or, if small enough,
a shell script.

Some may require additional Python packages to be installed systemwide, the most
common being [click](http://click.pocoo.org),
[jinja2](http://jinja.pocoo.org), and
[requests](http://python-requests.org).

## Nix

```nix
inputs.binbin.url = "github:mbr/binbin";
environment.systemPackages = [ inputs.binbin.packages.${pkgs.system}.default ];
```

## Graveyard

- `repl`: Moved to the dedicated [`repl`](https://github.com/mbr/repl) repository.
- `wrimg`: Moved to the dedicated [`wrimg`](https://github.com/mbr/wrimg) repository.
- `pgdb.sh`: Superseded by the dedicated
  [`pgdb`](https://github.com/mbr/pgdb-rs) tool.
- `ghci-color`: Removed because modern GHC provides colored diagnostics.
- `sstoggle`: Removed because its XScreenSaver-based implementation was unmaintained.
- `byzanz-record-window`: Removed because Byzanz was unmaintained.
- `compile-dts`: Removed because its device-tree compilation workflow had bit-rotted.
- `desktop-open`: Removed with the unused desktop application support.
- `xdg-gmail`: Removed because the Chrome-based Gmail launcher was unused.
