library(ggplot2)
library(readr)
library(tidyverse)

data_output_simu_model2 <- read_delim(file.choose(), delim = ";", escape_double = FALSE, trim_ws = TRUE)

params <- data_output_simu_model2[,1:7]
sims_popsize <- data_output_simu_model2[,8:57]
colnames(sims_popsize)<-seq(0:49)
sims_smurfprop <- data_output_simu_model2[,58:107]
sims_agepyrns <- data_output_simu_model2[,108:137]
colnames(sims_agepyrns)<-seq(0:29)

sims_agepyrs <- data_output_simu_model2[,138:167]
colnames(sims_agepyrs)<-seq(0:29)

ggplot(data_output_simu_model2)


pre_treated_data <- as.data.frame(cbind(t(data_output_simu_model2[,8:57]), t(data_output_simu_model2[,58:107])))
