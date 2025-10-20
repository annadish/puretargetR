#How puretargetR reconstructs motif composition

| Feature                | Description                             | Example                                                  |
| ---------------------- | --------------------------------------- | -------------------------------------------------------- |
| `repeat_unit`          | Ordered list of possible motifs         | `AAGGG:ACAGG:AGGGC:AAGGC:AGAGG:AAAAG:AAAGG:AAGAG:AAAGGG` |
| `motif_counts_allele0` | Counts of each motif in the order above | `0_0_0_0_0_11_0_0_0`                                     |
| `motif_counts_allele1` | Same, for the second allele             | `0_0_0_0_0_90_0_0_0`                                     |

Pairing `repeat_unit` with `motif_counts_allele` provides an overview of per-allele motif proportions:
> AAAAG → 11 / 11 = 1.00
> Others → 0 / 11 = 0

Dominant fraction (~1) → pure, homogeneous repeat 
Intermediate (0.5–0.9) → mixed or interrupted repeat motifs
Low (<0.5) → highly heterogeneous or mosaic repeat composition
