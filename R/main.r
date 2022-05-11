#!/usr/bin/env Rscript
# # Automated to run from terminal, see:
#   * README_scr2.md *
# Initial verification, creates output directories,
# checks biotypes,
# OUTPUT:  saves dds object into rds/ folder
# note : obj@row_data may have symbol_unique but empty external_gene_name:
#                      because when symbol retrieved by ncbi , not biomart.
# johaGL 2022
library(tidyverse)
library(biomaRt)
library(patchwork)
library(RColorBrewer)

args <- commandArgs(trailingOnly = TRUE)
gv <- yaml::read_yaml(args[1])

metadatafn <- gv$metadatafile
cfn <- gv$countsfile
conditionLEVELS <- gv$conditionLEVELS
reqcontrast <- gv$requiredcontrast
objecthasthiscontrast <- gv$objecthasthiscontrast
outname <- gv$outname
equi_id <- gv$equivalentid # inspect gene id's to know ('.'? --> _version) !
shortname <- gv$shortname

SPECIESensmbldsetname <- gv$SPECIESensmbldsetname
nb_bt <- gv$nb_bt # min nb of genes req for a biotype, for biotype to be displayed
samplestodrop <- gv$samplestodrop
typeRNAs <- gv$typeRNAs
# START
setwd(gv$mywdir)
source(paste0(gv$mywdir, "scr2/func.R"))
o_dir <- paste0(gv$mywdir, "results_", outname, "/")
resdirs <- getoutputdirs(outer = o_dir)
rds_dir <- resdirs[1]
tabl_dir <- resdirs[2]
plo_dir <- resdirs[3]
strcontrast <- paste(reqcontrast[2:3], collapse = "_vs_")

print("make sure samples names are ok, not being possible to change on the run")
print("if not the case, abort this and generate new matrix and metadata")
print("then put in your .yaml file those new paths ! ")
metadata <- read.table(metadatafn, header = TRUE, sep = ",")
rawc <- opentsv(cfn)
print_warnings_rawcdfANDmetadata(rawc, metadata)
print("")
############################ BIOTYPES LOAD    #############################
print(" * USING BIOMART FOR BIOTYPES AND MORE * ")
savebiomartinfos(SPECIESensmbldsetname, gv$mywdir, shortname)
bm_sp <- readRDS(paste0(gv$mywdir, "biomart_db/bm_", shortname, ".rds"))
print("")
############## matrix cross with biomart , then  rnaexp object   ##############

rawmat <- countsdftomatrix(rawc)
rowdatadf <- getfullRowsSymbols(rawmat, equi_id, bm_sp) # precursor for @row_data

# ----------- further query, omit dot and digits after-----------------------------
if (equi_id == "ensembl_gene_id_version") {
  rowdatadf <- furtherRowsSymbols(rowdatadf, equi_id, bm_sp)
  write.csv(data.frame("searchingfurther_ensembl_gene_id" = savedesperate),
    paste0(tabl_dir, "querybiomartsuppl.csv"),
    row.names = FALSE
  )
} else if (equi_id == "ensembl_gene_id") {
  print(paste(equi_id, "used ensembl_gene_id, no further query for rowdatadf"))
}
