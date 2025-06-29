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

## Example Usage

This example shows how to use Python functions within Tinybird pipes to create reusable query logic.

### Creating a Range Filter Endpoint

The `vehicles_by_ranges` endpoint demonstrates using Python utility functions in Tinybird queries:

**Weebill pipe** (`lib/tinybird/endpoints/vehicles_by_ranges.pipe`):

```sql
NODE vehicles_by_ranges_node
SQL >
    %
    SELECT
        vin__1_10_,
        make,
        model,
        model_year,
        electric_vehicle_type,
        electric_range,
        base_msrp,
        city,
        county,
        state
    FROM rows
    WHERE 1=1
    {%% if_defined('ranges', f"AND {get_ranges_filter('electric_range', 'ranges')}", '') %%}
    ORDER BY electric_range DESC, make ASC, model ASC
    LIMIT {{Int32(limit, 1000)}}

TYPE ENDPOINT
```

**Generated Tinybird pipe:**

```sql
NODE vehicles_by_ranges_node
SQL >
    %
    SELECT
        vin__1_10_,
        make,
        model,
        model_year,
        electric_vehicle_type,
        electric_range,
        base_msrp,
        city,
        county,
        state
    FROM rows
    WHERE
        1 = 1
        {% if defined(ranges) %}
            AND (
                0
                {% for range_val in ranges %}
                    OR (
                        {% if "min" not in range_val or range_val["min"] is None %}1
                        {% else %}electric_range >= {{ range_val["min"] }}
                        {% end %} AND {% if "max" not in range_val or range_val["max"] is None %} 1
                        {% else %} electric_range <= {{ range_val["max"] }}
                        {% end %}
                    )
                {% end %}
            )
        {% else %}
        {% end %}
    ORDER BY electric_range DESC, make ASC, model ASC
    LIMIT {{ Int32(limit, 1000) }}
```

## Development Setup

### Pre-commit Hooks

```bash
uv install
uv run pre-commit install
```

The pre-commit hooks will:

- Format Tinybird files (`.pipe`, `.datasource`, `.incl`) using `tb fmt`
- Validate Tinybird files using `tb check`
- Only process files in root directories (excludes `/lib` directory)

If formatting makes changes, you'll need to stage the changes and commit again.
