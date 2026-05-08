# Preprocessing dynamic characters <img src="figures/logo.jpg" align="right" width="120">


[![language](https://img.shields.io/badge/language-python-green?style=flat&logo=python&logoColor=green)](https://www.python.org)
[![author](https://img.shields.io/badge/author-DYM_Nakamura-green?logo=googlescholar&logoColor=green)](https://scholar.google.com/citations?user=c0W8Cm8AAAAJ&hl=en)
[![license](https://img.shields.io/badge/license-GPL_v3-green?logo=gnu&logoColor=green)](https://www.gnu.org/licenses/gpl-3.0.html)

**prepDyn** is a collection of Python scripts to facilitate the preprocessing of input sequences for dynamic homology. 

In dynamic homology, data should be preprocessed to distinguish differences in sequence length resulting from missing data or insertion-deletion events to avoid grouping from artifacts. However, previous empirical studies using POY and PhyG manually preprocessed data with varying approaches. Here we present **prepDyn**, a collection of Python scripts to facilitate the preprocessing of input sequences to POY/PhyG. The main script `prepDyn.py` comprises four steps: (1) data collection from GenBank, (2) trimming, (3) identification of missing data, and (4) partitioning.

Copyright (C) Daniel Y. M. Nakamura 2025

## Installation

### Manual installation

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
git clone https://github.com/dnakamuraz/prepDyn.git
```

### Docker

You can also run **prepDyn** with Docker. First, pull the published image from GitHub Container Registry (GHCR):

```bash
docker pull ghcr.io/dnakamuraz/prepdyn:v0.3.0
```

To see the help message of the main script:

```bash
docker pull ghcr.io/dnakamuraz/prepdyn:latest
```

To run **prepDyn** on files from your current directory, mount that directory into the container:

```bash
docker run --rm -v "$(pwd)":/work -w /work ghcr.io/dnakamuraz/prepdyn:v0.3.0 --help
```

You can also call the other scripts directly:

```bash
docker run --rm ghcr.io/dnakamuraz/prepdyn:v0.3.0 GB2MSA --help
docker run --rm ghcr.io/dnakamuraz/prepdyn:v0.3.0 addSeq --help
docker run --rm ghcr.io/dnakamuraz/prepdyn:v0.3.0 UP2AP --help
```

## Usage

<img src="figures/fig4_workflow.jpg" align="center" width="1200">

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
<summary>What is prepDyn used for?</summary>

**prepDyn** is used to preprocess DNA sequences for dynamic homology in **POY/PhyG**,
including trimming orphan nucleotides, handling missing data,
and generating partitions.

</details>

<details>
<summary>What is dynamic homology?</summary>

Two main strategies are used to align DNA sequences and determine homology. In static homology, sequences are first aligned using a similarity-based (= phenetic) multiple sequence alignment, and that fixed alignment is then evaluated across trees to find the lowest-cost tree. In dynamic homology, unaligned sequences are optimized directly on each tree during the search, and homologous nucleotides are inferred afterward from the best tree via implied alignments. Thus, dynamic homology accounts for alignment uncertainty, whereas static homology relies on a single possible alignment. Furthermore, dynamic homology uses the same optimality criterion throughout all steps, whereas static homology does not.

Finding the lowest-cost tree from unaligned sequences is NP-hard, so empirical analyses rely on heuristic methods (e.g. direct optimization and iterative-pass). Dynamic homology frequently finds more optimal hypotheses than static homology at the cost of computational resources (runtime and memory).

</details>

<details>
<summary>In addition to POY/PhyG, can prepDyn be used to preprocess input data for other phylogenetic programs?</summary>

Yes. If partitioning is skipped, **prepDyn** can still preprocess DNA sequences for other phylogenetic programs. The Step 3 is particularly useful to identify missing data and avoid downstream problems in software that treat gaps as a fifth character-state (e.g., TNT).

</details>

<details>
<summary>My sequences are too long and POY/PhyG is unable to start phylogenetic analyses. What should I do?</summary>

Dynamic homology implemented in **POY/PhyG** is NP-hard. If sequences are too long, use the parameter `partitioning_max_size`, so that sequences are initially split into equal-length partitions of size X before applying the partitioning methods (balanced, conservative, equal, maximum) in each resulting chunk.

</details>

<details>
<summary>How to specify missing data and multi-amplicons in the input CSV file?</summary>

In many cases, sequences are available for a few genes but not others. In this case, missing data should be indicated with the string "NA" in the CSV cell. Moreover, there are a few cases where researchers sequence the same gene from the same specimen and thus two or more GenBank accession numbers are available. These multi-amplicons can partially or fully share overlapping sequences. prepDyn allows overlapping regions from one of the sequences to be deleted or compute the consensus sequence.

</details>

<details>
<summary>What is the best partitioning strategy?</summary>

The best partitioning strategy is dataset-dependent and the user must test it empirically. Empirical analyses indicate that conservative, equal-length, and maximum partitioning perform better.

</details>

<details>
<summary>What are orphan nucleotides and which strategy is better to handle them?</summary>

Orphan nucleotides, defined as short stretches of nucleotides that appear separated from the main sequence block by long runs of gaps. These nucleotides can be artifacts from sequencing errors or alignment errors. As such ,orphan nucleotides should be either trimmed (`orphan_action trim`) or realigned (`orphan_action push`). 

Operationally, orphan nucleotides can be identified as contiguous nucleotide segments shorter than a user-defined threshold x, located at the flanks of a sequence and separated from the nearest substantial nucleotide block by gap regions longer than x. Because the optimal value of x depends on the characteristics of the dataset, it should be specified by the user (orphan_threshold) via visual inspection of alignment. Based on our experience, values between 10 and 30 generally perform well across many datasets. See also automatic methods available in `orphan_method`.

</details>

<details>
<summary>Can I detect orphan nucleotides automatically?</summary>

When a single orphan threshold is not feasible or visual inspection is too laborious in large datasets, adaptive orphan threshold can be specified with `orphan_method adaptive`, where the threshold is updated iteratively. 
  
a. Budgeting: Before doing anything, it calculates 5% of the length of each sequence (budget), which is the maximum percentage of sequence allowed to be trimmed.

b. Starting threshold: Instead of immediately using the user-provided `orphan_threshold`, the adaptive method starts its dynamic threshold at 1. The user-defined `orphan_threshold` acts as the maximum value of this dynamic threshold.

c. Iterative growth: It enters a loop where it looks strictly at the outermost left and outermost right contiguous blocks of nucleotides for every sequence. For a block to be considered an orphan under the "adaptive" method, it must meet three conditions: (1) the length of the block must be less than or equal to the current dynamic threshold, (2) modifying this block must not cause the sequence to exceed its 5% modification limit, and (3) other orphan blocks sharing exactly the same string cannot occur at the same position. If these conditions are met, the `orphan_action` is conducted (either trimming or realignment). If a change was made anywhere in the alignment, the script resets the dynamic threshold back to 1. This is because trimming or pushing an outer block exposes a new outer block, which might be a tiny 1-nucleotide orphan. If no changes were made, it increments the dynamic_threshold by 1 and scans the alignment again. 

Note that the length of contiguous gaps adjacent to contiguous nucleotides are considered in `orphan_method integer` but not in `orphan_method adaptive`.


</details>
