#!/usr/bin/env Rscript
# # Automated to run from terminal, see:
#   * README_scr2.md *
# Initial verification, creates output directories,
# checks biotypes,
# OUTPUT:  saves dds object into rds/ folder
# note : obj@row_data may have symbol_unique but empty external_gene_name:
#                      because when symbol retrieved by ncbi , not biomart.
# johaGL 2022


