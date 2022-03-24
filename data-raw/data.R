# load data from mind
library(mind)
library(dplyr)
data(data_s)
data(univ)
set.seed(1234)
## Example 1
# One random effect at domain level

formula<-as.formula(occ_stat~(1|mun)+
                      factor(sexage)+factor(edu)+factor(fore))

# Drop from the universe data frame variables not referenced in the formula or in the broadarea
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

## creazione matrice Gamma (H x D)
Gamma = data.frame(a=data$dom1, b=data$dom2)
Gamma<-model.matrix(~.-1,Gamma,contrasts.arg = lapply(Gamma, contrasts, contrasts=FALSE))


saeall_sample <- list(data=data, Gamma=Gamma, sigma_e=sigma_e, sigma_u=sigma_u)
usethis::use_data(saeall_sample, overwrite = TRUE, compress="gzip")
