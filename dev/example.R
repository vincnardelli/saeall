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
