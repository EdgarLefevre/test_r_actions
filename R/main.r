#!/usr/bin/env Rscript
# OUTPUT:  saves dds object into rds/ folder
# note : obj@row_data may have symbol_unique but empty external_gene_name:
#                      because when symbol retrieved by ncbi , not biomart.
# johaGL 2022

#' Add together two numbers
#'
#' @param x A number
#' @param y A number
#' @return The sum of \code{x} and \code{y}
#' @examples
#' add(1, 1)
#' add(10, 1)
add <- function(x, y) {
  x + y
}