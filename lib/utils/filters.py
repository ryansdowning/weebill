def get_ev_type_filter() -> str:
    return """
    {% if defined(ev_type) %}
        AND electric_vehicle_type = {{String(ev_type, '')}}
    {% end %}
    """.strip()


def get_range_filter(col_name: str, range_var_name: str) -> str:
    return f"""
        ({{% if "min" not in {range_var_name} or {range_var_name}["min"] is None %}}1
        {{% else %}}{{{{ {col_name} }}}} >= {{{{ {range_var_name}["min"] }}}}
        {{% end %}}
        AND {{% if "max" not in {range_var_name} or {range_var_name}["max"] is None %}} 1
        {{% else %}} {{ {col_name} }} <= {{{{ {range_var_name}["max"] }}}}
        {{% end %}})
    """.strip()


def get_ranges_filter(col_name: str, ranges_var_name: str) -> str:
    return f"""
        (0
        {{% for range_val in {ranges_var_name} %}}
            OR {get_range_filter(col_name, 'range_val')}
        {{% end %}})
    """.strip()