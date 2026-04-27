# Preprocessing dynamic characters <img src="figures/logo.jpg" align="right" width="120">


[![language](https://img.shields.io/badge/language-python-green?style=flat&logo=python&logoColor=green)](https://www.python.org)
[![author](https://img.shields.io/badge/author-DYM_Nakamura-green?logo=googlescholar&logoColor=green)](https://scholar.google.com/citations?user=c0W8Cm8AAAAJ&hl=en)
[![license](https://img.shields.io/badge/license-GPL_v3-green?logo=gnu&logoColor=green)](https://www.gnu.org/licenses/gpl-3.0.html)

**prepDyn** is a collection of Python scripts to facilitate the preprocessing of input sequences for dynamic homology. 

In dynamic homology, data should be preprocessed to distinguish differences in sequence length resulting from missing data or insertion-deletion events to avoid grouping from artifacts. However, previous empirical studies using POY and PhyG manually preprocessed data with varying approaches. Here we present **prepDyn**, a collection of Python scripts to facilitate the preprocessing of input sequences to POY/PhyG. The main script `prepDyn.py` comprises four steps: (1) data collection from GenBank, (2) trimming, (3) identification of missing data, and (4) partitioning.

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

<img src="figures/workflow.jpg" align="center" width="1200">

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

A summary of parameters available in `prepDyn.py` is [here](tables/parameters.md).

## Citation

If you use **prepDyn** in your research, cite this repository.

## Tutorial

Check the [**Wiki**](https://github.com/dnakamuraz/prepDyn/wiki/Tutorials) page for a tutorial. If you have questions, send a message using **GitHub issues**. Do not move the scripts from the directory *src*, otherwise the modular structure will break.

## FAQ

<details>
<summary>What is prepDyn used for?</strong></summary>

prepDyn is used to preprocess DNA sequences for dynamic homology in POY/PhyG,
including trimming orphan nucleotides, handling missing data,
and generating partitions.

</details>

<details>
<summary>Can prepDyn be used for phylogenetic programs other than POY/PhyG?</strong></summary>

Yes. If partitioning is skipped, prepDyn can still preprocess
DNA sequences for other phylogenetic programs that treat gaps
as a fifth character-state (e.g., TNT).

</details>

<details>
<summary>My sequences are too long and POY/PhyG are unable to start phylogenetic analyses. What should I do?</strong></summary>

Dynamic homology implemented in POY/PhyG is NP-hard. Thus, POY/PhyG is able to find better tree and alignment hypotheses than static homology at the cost of runtime and memory. If sequences are too long, use the parameter `partitioning_max_size`.  
If specified, sequences are initially split into equal-length
partitions of size X before applying the partitioning method. 

</details>