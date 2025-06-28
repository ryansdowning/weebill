# Weebill

Experimenting with Tinybird-Python-Jinja clickhouse query generation.

## How to use

- Treat the root Tinybird directories as generated files (`/connections`, `/copies`, `/datasources`, `/endpoints`, `/fixtures`, `/materializations`, `/pipes`, `/sinks`, `/tests`). Do not edit them as
  they will be overwritten by build the process.
- Instead, all development should be done in the `/lib/tinybird/*` copies of these
  files which the root files are then generated from.
- Use python, clickhouse, and tinybird syntax interchangeably in your development.
  - Python snippets should be written in a `.py` file of `/lib` while all other code
    is written to the `/lib/tinybird/` files.
  - Escape into python-land from tinybird/clickhouse by using the `{%% <python-code-here> %%}` syntax.
  - Do not worry about python imports, that is all handled for you by the build process.
