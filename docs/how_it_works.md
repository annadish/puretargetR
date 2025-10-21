# How puretargetR reconstructs motif composition

Pairing `repeat_unit` with `motif_counts_allele` provides an overview of per-allele motif proportions:

| Feature | Description | Example (Pure Allele) | Example (Heterogeneous Allele) |
|----------|--------------|-----------------------|--------------------------------|
| `repeat_unit` | Ordered list of possible motifs | `AAGGG:ACAGG:AGGGC:AAGGC:AGAGG:AAAAG:AAAGG:AAGAG:AAAGGG` | `AAGGG:ACAGG:AGGGC:AAGGC:AGAGG:AAAAG:AAAGG:AAGAG:AAAGGG` |
| `motif_counts_allele0` | Counts of each motif in the order above | `0_0_0_0_0_11_0_0_0` | `0_0_0_0_2_5_3_1_0` |
| `motif_counts_allele1` | Same, for the second allele | `0_0_0_0_0_90_0_0_0` | `0_1_2_0_0_7_2_0_0` |
| `consensus_size_allele0` | Consensus repeat size (bp or units) | `59` | `83` |
| `consensus_size_allele1` | Consensus repeat size (bp or units) | `454` | `472` |
| `read_count_allele0` | Number of reads supporting allele 0 | `180` | `163` |
| `read_count_allele1` | Number of reads supporting allele 1 | `169` | `151` |

> AAAAG → 11 / 11 = 1.00 \
> Others → 0 / 11 = 0

- Dominant fraction (~1) → pure, homogeneous repeat 
- Intermediate (0.5–0.9) → mixed or interrupted repeat motifs
- Low (<0.5) → highly heterogeneous or mosaic repeat composition
