def get_ev_type_filter() -> str:
    return """
    {% if defined(ev_type) %}
        AND electric_vehicle_type = {{String(ev_type, '')}}
    {% end %}
    """