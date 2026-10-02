#!/bin/bash

# ============================================================
# RNA-seq Mapping Workflow
# Arabidopsis thaliana
# ============================================================
# This workflow maps paired-end RNA-seq reads against the
# TAIR10 reference genome using HISAT2 and processes the
# alignments using SAMtools.
# ============================================================

# Input files
GENOME="/path/to/TAIR10_Chr.all.fasta"
R1="/path/to/clean_sample.R1.fq.gz"
R2="/path/to/clean_sample.R2.fq.gz"

# Sample name
SAMPLE="sample"

# ------------------------------------------------------------
# 1. Map reads with HISAT2
# ------------------------------------------------------------

hisat2 \
  --no-discordant \
  --no-mixed \
  -x "$GENOME" \
  -1 "$R1" \
  -2 "$R2" \
  2> "${SAMPLE}_hisat2.log" |

# ------------------------------------------------------------
# 2. Filter alignments by mapping quality (MAPQ >= 10)
# ------------------------------------------------------------

samtools view -h -q 10 - |

# ------------------------------------------------------------
# 3. Convert to BAM and sort
# ------------------------------------------------------------

samtools view -b - |
samtools sort -o "${SAMPLE}_filtered_sorted.bam"

# ------------------------------------------------------------
# 4. Create BAM index
# ------------------------------------------------------------

samtools index "${SAMPLE}_filtered_sorted.bam"

# ------------------------------------------------------------
# 5. Display mapping statistics
# ------------------------------------------------------------

samtools idxstats "${SAMPLE}_filtered_sorted.bam"