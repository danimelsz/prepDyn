List of parameters in prepDyn. Parameters can be either specified with long or short options.

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


