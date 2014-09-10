#' orderscore
#' 
#' Calculate pseudotemporal ordering scores for orders
#'
#' This function calculates pseudotemporal ordering scores (POS) based on the sub-population information and order information given by users.
#' Exactly two sub-population indicating early and late time points should be given. The early sub-population will be coded as 0 while the
#' late sub-population will be coded as 1. 
#'
#' @param subpopulation Data frame with two columns. First column: cell names. Second column: sub-population codes.
#' @param orders A list with various length containing pseudotime orderings. Each pseudotime ordering is typically the first element of the return value of function \code{\link{TSPpseudotime}}.
#' @return a numeric vector of calculated POS.
#' @export
#' @author Zhicheng Ji, Hongkai Ji <zji4@@zji4.edu>
#' @examples
#' library(HSMMSingleCell)
#' library(Biobase)
#' data(HSMM)
#' HSMMdata <- exprs(HSMM)
#' HSMMdata <- HSMMdata[,grep("T0|72",colnames(HSMMdata))]
#' procdata <- preprocess(HSMMdata)
#' subpopulation <- data.frame(cell = colnames(procdata), sub = ifelse(grepl("T0",colnames(procdata)),0,1), stringsAsFactors = FALSE)
#' MYOGexpr <- log2(HSMMdata["ENSG00000122180.4",]+1)
#' #Comparing ordering with or without marker gene information
#' order1 <- TSPpseudotime(procdata, geneexpr = MYOGexpr, dim = 2)
#' order2 <- TSPpseudotime(procdata, dim = 2)
#' orders <- list(order1[[1]],order2[[1]])
#' orderscore(subpopulation, orders)

orderscore <- function(subpopulation, orders) {
      subinfo <- subpopulation[,2]
      names(subinfo) <- subpopulation[,1]
      scorefunc <- function(order) {
            scoreorder <- subinfo[order[,1]]
            sum(sapply(1:(length(scoreorder)-1),function(x) {
                  sum(scoreorder[(x+1):length(scoreorder)] - scoreorder[x])
            })) / (sum(scoreorder==1)*sum(scoreorder==0))
      }      
      sapply(orders,scorefunc)      
}