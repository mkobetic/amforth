#!/usr/bin/env python3

"""
refcard reads the build/amforth.toc file in the current directory and produces a quick reference of words listed there.

It uses core/dev/categories to organize and sort the words. In the categories file, category definition starts with
category name and colon on the first line, followed by lines listing the words in order, offset from the start of the line by a tab.
Next category follows using the same format.

The .toc file consists of a single line for each word. The word line starts with the word type keyword (CODEWORD, COLON, ...), followed
by the word name in double quotes, followed by a symbolic label for the word, followed by optional comment that can include
the stack signature enclosed in parens, e.g. (n1 n2 -- n3), which can be followed by short description. The word line is terminated
by file/line reference separated from the rest of the line with character @.

The output of refcard is a series of tables, one for each category, listing the word name, stack signature and description
The output format can be simple columnar ascii, or html tables.
"""

import sys
import os
import re
import html
import argparse

def read_build_info():
    pattern = re.compile(r'^\s*STRING\s*"(.*)"')
    bits = []
    for fn in ['words/env-cpu.s', 'words/env-board.s', 'words/build-info.s']:
        with open(fn, 'r') as f:
            for line in f:
                match = pattern.match(line)
                if match:
                    bits.append(match.group(1))
    return bits

def parse_categories(filepath):
    """
    Parses the categories file.
    Returns a list of (category_name, [word_list]) tuples.
    """
    categories = []
    current_category = None
    current_words = []

    with open(filepath, 'r') as f:
        for line in f:
            line = line.rstrip()
            if not line:
                continue
            
            # Category definition: Name followed by colon
            if not line[0].isspace() and line.endswith(':'):
                if current_category:
                    categories.append((current_category, current_words))
                current_category = line[:-1]
                current_words = []
            # Word definition: Indented
            elif line[0].isspace():
                words = line.split()
                current_words.extend(words)
        
        # Append the last category
        if current_category:
            categories.append((current_category, current_words))

    return categories

def parse_toc(filepath, categories):
    """
    Parses the amforth.toc file.
    Returns a dictionary: { word_name: { 'signature': sig, 'description': desc } }
    Updates categories with an UNCATEGORIZED category containing
    words found in the TOC but not in the provided categories.
    """
    words_data = {}
    
    word_category_map = {}
    for _, words in categories:
        for word in words:
            word_category_map[word] = words
    uncategorized_set = set()
    mcu_words = set()
    
    if not os.path.exists(filepath):
        print(f"Error: TOC file not found at {filepath}", file=sys.stderr)
        return {}

    # Regex to capture: Type "Name" Label Comment @File
    # Example: CODEWORD "dup", DUP /* ( n -- n n ) Duplicate TOS */ @...
    pattern = re.compile(r'^(\w+)\s+"([^"]+)"\s*,\s*(\S+)\s*((.*)\s+@\s+(\S+))?$')

    with open(filepath, 'r') as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            
            match = pattern.match(line)
            if match:
                word_type = match.group(1)
                name = match.group(2)
                label = match.group(3)
                raw_comment = match.group(5).strip()
                location = match.group(6)
                location = os.path.normpath(location.replace('\\', '/'))
                
                if raw_comment.startswith("/*") and raw_comment.endswith("*/"):
                    raw_comment = raw_comment[2:-2].strip()
                elif raw_comment.startswith("@") or raw_comment.startswith("#"):
                    raw_comment = raw_comment[1:].strip()
                signature = ""
                description = raw_comment
                
                # Extract stack signature ( ... )
                sig_match = re.match(r'^(\([^\)]+\))\s*(.*)$', raw_comment)
                if sig_match:
                    signature = sig_match.group(1)
                    description = sig_match.group(2)
                
                words_data[name] = {
                    'type': word_type,
                    'label': label,
                    'signature': signature,
                    'description': description,
                    'location': location
                }
                
                
                if 'mcu' in location.split('/'):
                    is_mcu = True
                    mcu_words.add(name)
                    uncategorized_set.discard(name)
                    if name in word_category_map:
                        word_category_map[name].remove(name)
                        del word_category_map[name]
                elif name not in word_category_map:
                    uncategorized_set.add(name)
    
    if mcu_words:
        categories.append(("MCU", sorted(mcu_words)))
    if uncategorized_set:
        categories.append(("UNCATEGORIZED", sorted(uncategorized_set)))
    
    return words_data

def generate_refcard(categories_file, toc_file):
    categories = parse_categories(categories_file)
    words_db = parse_toc(toc_file, categories)
    
    if not categories or not words_db:
        return

    # Column widths
    w_name = 20
    w_sig = 30
    
    # Header
    print(f"{'Word':<{w_name}} {'Stack Signature':<{w_sig}} Description")
    print("=" * 80)

    for cat_name, word_list in categories:
        print(f"\n{cat_name}")
        print("-" * len(cat_name))
        
        # Compute optimal column widths for this category
        w_name = 0
        w_sig = 0
        for word in word_list:
            w_name = max(w_name, len(word))
            data = words_db.get(word)
            if data:
                w_sig = max(w_sig, len(data['signature']))

        for word in word_list:
            data = words_db.get(word)
            if data:
                name = word
                sig = data['signature']
                desc = data['description']
                print(f"{name:<{w_name}} {sig:<{w_sig}} {desc}")
            else:
                # Word in category but not in TOC
                print(f"{word:<{w_name}} {'':<{w_sig}}")

def generate_html_refcard(categories_file, toc_file):
    categories = parse_categories(categories_file)
    words_db = parse_toc(toc_file, categories)
    build_info = " ".join(read_build_info())
    
    if not categories or not words_db:
        return

    print("<!DOCTYPE html>")
    print("<html>")
    print("<head>")
    print("<title>AmForth Reference Card</title>")
    print("<style>")
    print("body { font-family: sans-serif; }")
    print("table { border-collapse: collapse; width: 100%; margin-bottom: 20px; }")
    print("th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }")
    print("th { background-color: #f2f2f2; }")
    print("h2 { border-bottom: 2px solid #333; padding-bottom: 5px; }")
    print("</style>")
    print("</head>")
    print("<body>")
    print("<h1>AmForth Reference Card</h1>")
    print(f'<h2>{build_info}</h2>')

    print("<p>")
    links = []
    for cat_name, _ in categories:
        anchor = html.escape(cat_name)
        links.append(f'<a href="#{anchor}">{anchor}</a>')
    print(" | ".join(links))
    print("</p>")

    for cat_name, word_list in categories:
        print(f'<h2 id="{html.escape(cat_name)}">{html.escape(cat_name)}</h2>')
        print("<table>")
        print("<tr><th>Word</th><th>Type</th><th>Stack Signature</th><th>Description</th><th>Location</th></tr>")
        
        for word in word_list:
            data = words_db.get(word)
            if data:
                name = html.escape(word)
                typ = html.escape(data['type'])
                sig = html.escape(data['signature'])
                desc = html.escape(data['description'])
                loc = html.escape(data['location'])
                print(f"<tr><td>{name}</td><td>{typ}</td><td>{sig}</td><td>{desc}</td><td>{loc}<td></tr>")
            else:
                name = html.escape(word)
                print(f"<tr><td>{name}</td></tr>")
        print("</table>")

    print("</body>")
    print("</html>")

if __name__ == "__main__":
    # Default paths based on description
    script_dir = os.path.dirname(os.path.abspath(__file__))
    default_categories = os.path.join(script_dir, "../core/dev/categories")
    
    parser = argparse.ArgumentParser(description="Generate AmForth reference card")
    parser.add_argument("toc_path", nargs='?', default="build/amforth.toc", help="Path to amforth.toc file")
    parser.add_argument("categories_path", nargs='?', default=default_categories, help="Path to categories file")
    parser.add_argument("--html", action="store_true", help="Output in HTML format")
    
    args = parser.parse_args()
    
    if args.html:
        generate_html_refcard(args.categories_path, args.toc_path)
    else:
        generate_refcard(args.categories_path, args.toc_path)