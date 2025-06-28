from lib.utils.filters import *
from pathlib import Path
import re

# Regex to match the weebill format of {%% ... %%}
WEEBILL_REGEX = r"{%%\s*(.+?)\s*%%}"

def build_weebill(input_dir: str, output_dir: str) -> None:
    # Recurse over all files in the input directory
    for file in Path(input_dir).rglob():
        if file.is_file():
            with open(file, "r") as fp:
                content = fp.read()
                for match in re.finditer(WEEBILL_REGEX, content):
                    macro = match.group(1)
                    eval_content = eval(macro)
                    content = content.replace(match.group(0), eval_content)
            
            output_path = Path(output_dir) / file.relative_to(input_dir)
            output_path.parent.mkdir(parents=True, exist_ok=True)
            with open(output_path, "w") as fp:
                fp.write(content)
                
if __name__ == "__main__":
    build_weebill("lib/tinybird/", ".")