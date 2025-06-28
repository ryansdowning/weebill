def if_defined(var_name: str, true_val: str, false_val: str) -> str:
    return f"""
    {{% if defined({var_name}) %}}
    {true_val}
    {{% else %}}
    {false_val}
    {{% end %}}
    """.strip()