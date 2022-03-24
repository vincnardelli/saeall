# saeall: Sampling Allocation for Small Area Estimation

<!-- badges: start -->
<!-- badges: end -->

The R package **saeall** implements a proper statistical setting for defining the sampling design for a small area estimation problem. The general random sampling framework is based on sampling without replacement and with varying inclusion probabilities. The sample is selected with the cube method based on balancing sampling equations useful in the small area situation. This method allows to obtain the minimum-cost sampling solution.

## Installation
The package is work in progress and it is not available in the CRAN. However you can install it directly from the github repo.
``` r
# The easiest way to get saeall is to install it from GitHub:
# install.packages("devtools")
devtools::install_github("vincnardelli/saeall")
```

## Example of usage

This is a basic example which shows you how use saeall:

``` r
library(saeall)

Nh <-saeall_sample$data$Nh
Gamma <- saeall_sample$Gamma
sigma_u <- saeall_sample$sigma_u
sigma_e <- saeall_sample$sigma_e
data <- saeall_sample$data
Nd<-t(Gamma) %*% Nh
cv <- c(rep(0.07, times=49), 0.05, 0.05)
med<- data$occ_stat_2/Nh
med <- c(med, mean(med), mean(med))
Vd_star<-cv^2*(t(Nd)*med)^2

res <- allocation(Nh, Gamma, sigma_u, sigma_e, Vd_star)
res
```

In alternative you can use saeall directly from mind output:
``` r
library(saeall)
library(mind)
library(dplyr)

data(data_s)
data(univ)
set.seed(1234)

formula<-as.formula(occ_stat~(1|mun)+
                      factor(sexage)+factor(edu)+factor(fore))
univ_1<-univ[,-6]
example.1<-mind.unit(formula=formula,dom="dom",data=data_s,universe=univ_1)

data <- example.1$EBLUP %>% 
  left_join(example.1$mse_EBLUP, by = "dom") %>% 
  left_join(example.1$Nd, by = "dom") %>% 
  left_join(example.1$cv_EBLUP, by = "dom") %>% 
  right_join(example.1$nd, by = "dom") %>% 
  select("dom", "occ_stat_2", 
         "G1_occ_stat_2", "G2_occ_stat_2", "G3_occ_stat_2", 
         "Nh"="Nd", "cv_EBLUP"="CV_occ_stat_2", "nh_old"="nd") %>% 
  filter(G1_occ_stat_2 != 0) %>% 
  mutate(dom1 = as.factor(1:nrow(.)), 
         dom2 = as.factor(sample(1:2, nrow(.), replace = T)),
         Nh = ifelse(Nh < 1000, Nh, Nh))

sigma_e <- example.1$sigma_e$`sigma_e_ occ_stat_2`^2
sigma_u <- example.1$sigma_u$`sigma_u_ occ_stat_2`^2

Gamma = data.frame(a=data$dom1, b=data$dom2)
Gamma<-model.matrix(~.-1,Gamma,contrasts.arg = lapply(Gamma, contrasts, contrasts=FALSE))

Nh <-saeall_sample$data$Nh
Gamma <- saeall_sample$Gamma
sigma_u <- saeall_sample$sigma_u
sigma_e <- saeall_sample$sigma_e
data <- saeall_sample$data
Nd<-t(Gamma) %*% Nh
cv <- c(rep(0.07, times=49), 0.05, 0.05)
med<- data$occ_stat_2/Nh
med <- c(med, mean(med), mean(med))
Vd_star<-cv^2*(t(Nd)*med)^2

res <- allocation(Nh, Gamma, sigma_u, sigma_e, Vd_star)
res
```


