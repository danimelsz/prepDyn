#!/usr/bin/env python3
#-*- coding: utf-8 -*-

import argparse
import re
import os

def load_synonyms(synonym_file):
    """
    Loads a synonym file into a dictionary mapping old names to the new name.
    """
    synonyms = {}
    with open(synonym_file, 'r') as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            # Split by comma, tab, or space
            parts = re.split(r'[ \t,]+', line)
            if len(parts) > 1:
                new_name = parts[0]
                for old_name in parts[1:]:
                    synonyms[old_name] = new_name
    return synonyms

def rename_matrix(matrix_file, synonyms, output_file):
    """
    Replaces occurrences of old names with new names in the matrix file.
    """
    with open(matrix_file, 'r') as f:
        content = f.read()

    # Sort old names by length, descending, to prevent partial replacements
    # (e.g., we want to replace 'sp1_old_name2' before 'sp1_old_name')
    sorted_old_names = sorted(synonyms.keys(), key=len, reverse=True)

    for old_name in sorted_old_names:
        new_name = synonyms[old_name]
        # Perform a direct string replacement. This works well for Fasta, Nexus, and TNT formats
        # because terminal names usually don't overlap with sequence characters or matrix syntax.
        content = content.replace(old_name, new_name)
        
    with open(output_file, 'w') as f:
        f.write(content)

def main():
    parser = argparse.ArgumentParser(description="Rename terminal names in a matrix based on a list of synonyms.")
    parser.add_argument("synonym_input", help="Text file containing list of new name in first column, separated by space/tab/comma of synonyms.")
    parser.add_argument("matrix_input", help="Fasta, tnt, or nexus input file.")
    parser.add_argument("-o", "--output", help="Output file name. If not provided, will append '_renamed' to the input matrix filename.")

    args = parser.parse_args()

    synonyms = load_synonyms(args.synonym_input)
    
    if args.output:
        output_file = args.output
    else:
        base, ext = os.path.splitext(args.matrix_input)
        output_file = f"{base}_renamed{ext}"
        
    rename_matrix(args.matrix_input, synonyms, output_file)
    print(f"Renamed matrix saved to: {output_file}")

if __name__ == "__main__":
    main()
