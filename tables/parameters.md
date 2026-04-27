List of parameters in prepDyn. Parameters can be either specified with long or short options.

| **Parameter**                       | **Type**              | **Default**  | **Description**                                                                   |
| ----------------------------------- | --------------------- | ------------ | --------------------------------------------------------------------------------- |
| `input_file` or `i`                 | `str`                 | –            | Path to an alignment file or directory of alignments.                             |
| `GB_input` or `gb`                  | `str`                 | –            | Path to a CSV/TSV of GenBank accessions. Overrides `input_file`.                  |
| `input_format` or `if`              | `str`                 | `"fasta"`    | Format of input file(s) (e.g., `fasta`, `clustal`).                          |
| `MSA` or `msa`                      | `bool`                | `False`      | If `True`, perform multiple sequence alignment on unaligned input sequences.      |
| `output_file` or `o`                | `str`                 | –            | Custom prefix for output files.                                                   |
| `output_format` or `of`             | `str`                 | `"fasta"`    | Format for the output alignment.                                                  |
| `log` or `l`                        | `bool`                | `False`      | Write a detailed log file.                                                        |
| `sequence_names` or `s`             | `bool`                | `True`       | Write a file with all unique sequence names.                                      |
| `orphan_method` or `om`             | `str`                 | `None`       | Method to trim orphan nucleotides: `percentile`, `integer`, or `None`.                 |
| `orphan_action` or `oa`             | `str`                 | `None`       | Action for orphan nucleotides. 'trim' (default) removes them. 'push' moves them adjacent to the next block iteratively.                 |
| `orphan_threshold` or `ot`          | `int`                 | `10`         | Manual length threshold for `orphan_method integer`.                               |
| `percentile` or `op`                | `float`               | `25`         | Percentile for `orphan_method percentile`.                                            |
| `del_inv` or `di`                   | `bool`                | `True`       | Trim invariant columns from alignment ends.                                       |
| `internal_method` or `g2q`          | `str`                 | `None`       | Method to replace internal gaps with `?`: `manual`, `semi`, or `None`.        |
| `internal_column_ranges` or `g2q_c` | `list`                | –            | Column ranges (e.g., `[[10, 20]]`) for `manual` method.                         |
| `internal_leaves` or `g2q_l`        | `str` or `list`       | `"all"`      | Sequences to apply internal gap replacement to.                                   |
| `internal_threshold` or `g2q_t`     | `int`                 | –            | Gap length threshold for `semi` method.                                         |
| `n2question` or  `n2q`              | `str`, `list`, `None` | `None`       | Replace ambiguous `N` with `?`. Options: `all`, list of names, or `None`.     |
| `partitioning_method` or `pm`       | `str`                 | `"conservative"` | Method to insert `#` markers: `balanced`, `conservative`, `equal`, `max`, or `None`.  |
| `partitioning_round` or `pr`        | `int`                 | `0`          | Number of rounds/selected blocks for relevant partitioning methods.  |
| `partitioning_conservative` or `pc` | `str`                 | `"midpoint"` | Placement mode when `partitioning_method='conservative'`: `'midpoint'` inserts one `#` at the midpoint of each selected invariant block, and `'flank'` inserts `#` columns around each selected invariant block. |
| `partitioning_max_size` or `pms`    | `int`                 | –            | Initial maximum partition size. If specified, the alignment is first split into equal-length partitions of this size, and the selected partitioning method is then applied independently within each resulting partition. |
| `partitioning_size` or `ps`         | `int`                 | –            | Partition size for `partitioning_method='equal'`.                                 |
