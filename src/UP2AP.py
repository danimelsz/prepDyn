#!/usr/bin/env python3
#-*- coding: utf-8 -*-

# UP2AP.py
# prepDyn - Copyright (C) 2025
# Daniel Y. M. Nakamura
# GNU General Public Licence version 3.0
# Contact: dani_ymn@outlook.com

COPYRIGHT=""""
UP2AP.py is part of prepDyn.

prepDyn - Data preprocessing for dynamic homology
Copyright (C) 2025 - Daniel Y. M. Nakamura
    prepDyn comes with ABSOLUTELY NO WARRANTY!
    This is a free software, and you are welcome to
    redistribute them under certain conditions
    For additional information, please visit:
    http://opensource.org/licenses/GPL-3.0
"""
print(COPYRIGHT)

###########
# MODULES #
###########

# The program mafft should be installed in $PATH beforehand.
# The Python modules can be automatically installed using the
# following script. If already installed, it will load them.

import subprocess
import sys
import importlib

def install_and_import(package_name, import_path, from_list=None, alias=None):
    try:
        if from_list:
            module = importlib.import_module(import_path)
            for name in from_list:
                globals()[name] = getattr(module, name)
        else:
            globals()[alias or import_path] = importlib.import_module(import_path)
    except ModuleNotFoundError:
        print(f"Installing: {package_name}")
        subprocess.check_call([sys.executable, "-m", "pip", "install", package_name])
        # Try importing again after installation
        if from_list:
            module = importlib.import_module(import_path)
            for name in from_list:
                globals()[name] = getattr(module, name)
        else:
            globals()[alias or import_path] = importlib.import_module(import_path)

# Biopython modules
install_and_import("biopython", "Bio.AlignIO", from_list=["read", "write"])
install_and_import("biopython", "Bio.Entrez", from_list=["efetch", "email"])
install_and_import("biopython", "Bio.SeqIO", from_list=["parse", "write"])
install_and_import("biopython", "Bio.Align", from_list=["MultipleSeqAlignment"])
install_and_import("biopython", "Bio.Seq", from_list=["Seq"])
install_and_import("biopython", "Bio.SeqRecord", from_list=["SeqRecord"])

# Other useful packages
install_and_import("matplotlib", "matplotlib.pyplot", alias="plt")
install_and_import("numpy", "numpy", alias="np")
install_and_import("termcolor", "termcolor", from_list=["colored"])

# Standard libraries (should not need installation)
import argparse
import ast
import csv
from io import StringIO
import os
import pathlib
import re
import shutil
import subprocess
import tempfile
import time

# prepDyn libraries
from prepDyn_auxiliary import UP2AP
from Bio import SeqIO
from Bio.Seq import Seq
from Bio.SeqRecord import SeqRecord

########
# MAIN #
########

def str2bool(v):
    if isinstance(v, bool):
       return v
    if v.lower() in ('yes', 'true', 't', '1'):
        return True
    elif v.lower() in ('no', 'false', 'f', '0'):
        return False
    else:
        raise argparse.ArgumentTypeError('Boolean value expected.')

def main():
    parser = argparse.ArgumentParser(
        description="Convert unaligned sequences containing pound signs '#' or '?' into aligned sequences.",
        formatter_class=argparse.RawTextHelpFormatter,
        epilog="""\
Examples: python UP2AP.py -i aln.fas -o aln_updated.fas -k
          python UP2AP.py -i aln.fas -o aln_updated.fas -k True
          python UP2AP.py -i aln.fas -o aln_updated.fas -k False
""")
    
    parser.add_argument("-i", "--input_fasta", type=str, required=True, help="Path to FASTA input of unaligned sequences containing pound signs.", default=None)
    parser.add_argument("-o", "--output_fasta", type=str, required=False, help="Path to FASTA output of aligned sequences containing pound signs.", default=None)     
    parser.add_argument("-k", "--keep_unusual", nargs="?", const=True, default=False, type=str2bool, help="Keep the pound signs (#) and question marks (?) in the output. Accepts flag-only, True, or False. Default is False.")

    args = parser.parse_args()
    if not args.output_fasta:
        print("output_file was not provided.")
        return

    UP2AP(
        input_fasta=args.input_fasta, 
        output_fasta=args.output_fasta,
        keep_unusual=args.keep_unusual)

if __name__ == "__main__":
    main()
