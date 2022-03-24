#' Allocation
#'
#'This package implements a proper statistical setting for defining 
#'the sampling design for a small area estimation problem. 
#'The general random sampling framework is based 
#'on sampling without replacement and with varying inclusion probabilities. 
#'The sample is selected with the cube method based on
#'balancing sampling equations useful in the small area situation. 
#'This method allows to obtain the minimum-cost sampling solution.
#'
#' @param Nh Nh vector
#' @param Gamma Gamma matrix with partitions
#' @param sigma_u Sigma U variance
#' @param sigma_e Sigma E variance
#' @param Vd_star Costrain values
#' @param n0 Starting value
#' @param seed Seed
#'
#' @return A list
#' \describe{
#'   \item{nh}{nh optimal allocation}
#'   \item{nd}{nd optimal allocation}
#'   \item{nloptr}{nloptr object}
#'   \item{conv}{Dataframe with convergence of the optimization algoritm}
#' }
#' @export
#'
#' @examples
#' Nh <-saeall_sample$data$Nh
#' Gamma <- saeall_sample$Gamma
#' sigma_u <- saeall_sample$sigma_u
#' sigma_e <- saeall_sample$sigma_e
#' data <- saeall_sample$data
#' Nd<-t(Gamma) %*% Nh
#' cv <- c(rep(0.07, times=49), 0.05, 0.05)
#' med<- data$occ_stat_2/Nh
#' med <- c(med, mean(med), mean(med))
#' Vd_star<-cv^2*(t(Nd)*med)^2
#' 
#' res <- allocation(Nh, Gamma, sigma_u, sigma_e, Vd_star)
#' res
#' @importFrom nloptr nloptr
#' @importFrom utils capture.output
#' @importFrom stringr str_extract_all

allocation <- function(Nh, Gamma, sigma_u, sigma_e, Vd_star, n0=1, seed=1234){
  n0<-as.vector(rep(n0,length(Nh)))
  
  objfun <- function(n){
    sum(n)
  }
  eval_g_ineq=function(n){
    f = (t(Gamma)%*%Nh)^2*sigma_u*sigma_e/(t(Gamma)%*%n*sigma_u+sigma_e) - t(Vd_star)
    return(f)
  }
  sol.output <- capture.output(res <- nloptr::nloptr(x0=n0, 
                eval_f=objfun,
                eval_g_ineq = eval_g_ineq,
                eval_g_eq = NULL,
                lb = rep(1, length(Nh)),
                ub = Nh,
                opts = list("algorithm"="NLOPT_LN_COBYLA", 
                            "print_level"=1, 
                            "maxeval" = 20000, 
                            "xtol_rel"=0.01, 
                            "seed"=seed)))
  
  sol.hist <- sol.output[grepl("\tf",sol.output)] #get all lines starting with a tab and x (Those are the lines with the variables)
  sol.hist <- sapply(stringr::str_extract_all(sol.hist,"[0-9]+\\.[0-9]+"),as.numeric) # Extract all numbers and convert to numeric
  conv <- data.frame(n=1:res$iterations, fx=sol.hist)

  nh <- round(res$solution, 0)
  
  ret <- list(nh=nh, 
              nd=round(t(Gamma) %*% nh),
              nloptr=res,
              conv=conv)
  return(ret)
  
}
