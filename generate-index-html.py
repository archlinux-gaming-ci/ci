import os
import sys
import html
import urllib.parse
from datetime import datetime


def generate_index(folder, root_folder):
    entries = os.listdir(folder)
    header_text = html.escape(os.path.relpath(folder, root_folder))
    out_html = f"<html><head><title>{header_text}</title></head><body><h1>{header_text}</h1><ul>"

    for entry in sorted(entries):
        if entry == "index.html":
            continue

        full_path = os.path.join(folder, entry)
        mtime = os.path.getmtime(full_path)
        mdate = datetime.fromtimestamp(mtime).strftime("%Y-%m-%d %H:%M:%S")

        safe_name = html.escape(entry)

        if os.path.isdir(full_path):
            safe_link = urllib.parse.quote(entry) + "/index.html"
        else:
            safe_link = urllib.parse.quote(entry)

        out_html += f'<li><a href="{safe_link}">{safe_name}</a> {mdate}</li>'

    out_html += "</ul></body></html>"

    with open(os.path.join(folder, "index.html"), "w", encoding="utf-8") as f:
        f.write(out_html)

    for entry in entries:
        if entry == "index.html":
            continue
        full_path = os.path.join(folder, entry)
        if os.path.isdir(full_path):
            generate_index(full_path, root_folder)


def main():
    root_folder = os.path.abspath(sys.argv[1])
    generate_index(root_folder, root_folder)


if __name__ == "__main__":
    main()
