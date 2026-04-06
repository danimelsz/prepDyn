# Preprocessing dynamic characters <img src="figures/logo.jpg" align="right" width="120">


[![language](https://img.shields.io/badge/language-python-green?style=flat&logo=python&logoColor=green)](https://www.python.org)
[![author](https://img.shields.io/badge/author-DYM_Nakamura-green?logo=googlescholar&logoColor=green)](https://scholar.google.com/citations?user=c0W8Cm8AAAAJ&hl=en)
[![license](https://img.shields.io/badge/license-GPL_v3-green?logo=gnu&logoColor=green)](https://www.gnu.org/licenses/gpl-3.0.html)

**prepDyn** is a collection of Python scripts to facilitate the preprocessing of input sequences for dynamic homology. 

In dynamic homology, data should be preprocessed to distinguish differences in sequence length resulting from missing data or insertion-deletion events to avoid grouping from artifacts. However, previous empirical studies using POY (Wheeler et al. 2015) and PhyG (Wheeler et al. 2024) manually preprocessed data with varying approaches (e.g. Grant et al. 2006; Nakamura et al. 2025). Here we present **prepDyn**, a collection of Python scripts to facilitate the preprocessing of input sequences to POY/PhyG. The main script `prepDyn.py` comprises four steps: (1) data collection from GenBank, (2) trimming, (3) identification of missing data, and (4) partitioning.

Copyright (C) Daniel Y. M. Nakamura 2025

## Installation

The two dependencies that should be installed beforehand by the user are:
- Python v. 3.10.9 (or newer), including *argparse*, *ast*, *csv*, *importlib*, *re*, *StringIO*, *subprocess*, *sys*, *tempfile*, and *time*, which are usually part of recent versions of Python.
- MAFFT v. 7.5.2 (or newer), installed in $PATH as 'mafft'.

```
# Create a conda environmnt called 'prepdyn'
conda create -n prepdyn python=3.10 --yes

# Inside the newly created environment, install 'mafft'
conda activate prepdyn
conda install bioconda::mafft
```

Other dependencies are Python modules that will be automatically installed by **prepDyn** when you run it for the first time:
- Bio v. 1.73 (or newer), including *AlignIO*, *Entrez*, *SeqIO*, *Align*, *Seq*, and *SeqRecord*.
- matplotlib v. 3.7.0 (or newer)
- numpy v. 1.23.5 (or newer)
- termcolor

If the  modules are not installed automatically, try:

```
conda install conda-forge::biopython
conda install conda-forge::matplotlib
conda install anaconda::numpy
conda install conda-forge::termcolor
```

Finally, clone the **prepDyn** repository using the command:

```
git clone https://github.com/dnakamuraz/PrepDyn.git
```

## Usage

**prepDyn** is organized in four stand-alone Python scripts in the directory src:
| Script        | Description                                                                 |
|----------------|-----------------------------------------------------------------------------|
| `prepDyn.py`   | The main script integrating the pipeline.                                   |
| `GB2MSA.py`    | Downloads sequences from GenBank and identifies internal missing data.     |
| `addSeq.py`    | Aligns one or a few sequence(s) to a previously preprocessed alignment.    |
| `UP2AP.py`     | Aligns sequences containing pound signs.                                    |

The main script is `prepDyn.py`, which comprises four steps: 

- (1) Data collection: Based on a CSV dataframe containing GenBank accession numbers or FASTA sequences in a local directory

- (2) Trimming: Deletion of flanking invariants and orphan nucleotides

- (3) Identification of missing data: Internal missing data identified in the first step or specified by the user; flanking gaps are automatically corrected to missing characters

- (4) Successive partitioning: Pound signs are inserted sucessively until tree costs stabilize. Position of pound signs defined by partitioning strategies (balanced, conservative, equal-length, and maximum), which are competitive via tree costs. Recommended for large datasets.

A summary of parameters used in `prepDyn.py` are summarized below. Parameters can be either specified with long or short options.

| **Parameter**            | **Type**              | **Default**  | **Description**                                                                   |
| ------------------------ | --------------------- | ------------ | --------------------------------------------------------------------------------- |
| `input_file`             | `str`                 | –            | Path to an alignment file or directory of alignments.                             |
| `GB_input`               | `str`                 | –            | Path to a CSV/TSV of GenBank accessions. Overrides `input_file`.                  |
| `input_format`           | `str`                 | `"fasta"`    | Format of input file(s) (e.g., `"phylip"`, `"clustal"`).                          |
| `MSA`                    | `bool`                | `False`      | If `True`, perform multiple sequence alignment on unaligned input sequences.      |
| `output_file`            | `str`                 | –            | Custom prefix for output files.                                                   |
| `output_format`          | `str`                 | `"fasta"`    | Format for the output alignment.                                                  |
| `log`                    | `bool`                | `False`      | Write a detailed log file.                                                        |
| `sequence_names`         | `bool`                | `True`       | Write a file with all unique sequence names.                                      |
| `orphan_method`          | `str`                 | `None`       | Method to trim orphan nucleotides: `'percentile'`, `'integer'`, or `None`.                 |
| `orphan_threshold`       | `int`                 | `10`         | Manual length threshold for `orphan_method='integer'`.                               |
| `percentile`             | `float`               | `25`         | Percentile for `orphan_method='auto'`.                                            |
| `del_inv`                | `bool`                | `True`       | Trim invariant columns from alignment ends.                                       |
| `internal_method`        | `str`                 | `None`       | Method to replace internal gaps with `?`: `'manual'`, `'semi'`, or `None`.        |
| `internal_column_ranges` | `list`                | –            | Column ranges (e.g., `[[10, 20]]`) for `'manual'` method.                         |
| `internal_leaves`        | `str` or `list`       | `"all"`      | Sequences to apply internal gap replacement to.                                   |
| `internal_threshold`     | `int`                 | –            | Gap length threshold for `'semi'` method.                                         |
| `n2question`             | `str`, `list`, `None` | `None`       | Replace ambiguous `'N'` with `?`. Options: `'all'`, list of names, or `None`.     |
| `partitioning_method`    | `str`                 | `"balanced"` | Method to insert `#` markers: `'balanced'`, `'conservative'`, `'equal'`, `'max'`. |
| `partitioning_round`     | `int`                 | `0`          | Number of partitions/rounds for relevant partitioning methods.                    |
| `partitioning_size`      | `int`                 | –            | Partition size for `partitioning_method='equal'`.                                 |


## Tutorial

Check the [**Wiki**](https://github.com/dnakamuraz/prepDyn/wiki/Tutorials) page for a tutorial. If you have questions, send a message using **GitHub issues**. Do not move the scripts from the directory *src*, otherwise the modular structure will break.

## Citation

If you use **prepDyn** in your research, cite this repository.

## References

Grant T et al. (2006) Phylogenetic systematics of dart-poison frogs and their relatives (Amphibia: Athesphatanura: Dendrobatidae). *Bull Am Mus Nat Hist* 2006(299):1-262.

Nakamura DYM et al. (2025) Museomics reduces taxonomic inflation in the *Dendropsophus araguaya* complex (Hylinae: Dendropsophini) from the Cerrado. *Journal of Vertebrate Biology* 74:24112.

Wheeler WC et al. (2015) POY version 5: phylogenetic analysis using dynamic homologies under multiple optimality criteria. *Cladistics* 31:189-196.

Wheeler WC et al. (2024) PhylogeneticGraph (PhyG) a new phylogenetic graph search and optimization program. *Cladistics* 40(1):97-105.
