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

## Other useful things

Additional tools that would fit into binbin, but have grown enough to warrant
their own repository:

- https://github.com/mbr/repl
- https://github.com/mbr/wrimg

## Graveyard

- `pgdb.sh`: Superseded by the dedicated
  [`pgdb`](https://github.com/mbr/pgdb-rs) tool.
- `desktop-open`: Removed with the unused desktop application support.
- `xdg-gmail`: Removed because the Chrome-based Gmail launcher was unused.
