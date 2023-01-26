library(ggplot2)
library(readr)
library(tidyverse)

#library(Rcmdr)

data4plot <- as.data.frame(cbind(paste("cond_",seq(1:21),sep=""),read_delim(file.choose(), delim = ";", escape_double = FALSE, trim_ws = TRUE)))
colnames(data4plot)[1] <- "conditions"

params <- data4plot[,1:8]

pop_size <- as.data.frame(cbind(seq(0:49),t(data4plot[,9:58])))
colnames(pop_size) <- c("time",data4plot$conditions)

Smurf_prop <- as.data.frame(cbind(seq(0:49),t(data4plot[,59:108])))
colnames(Smurf_prop) <- c("time",data4plot$conditions)

pyr_age_ns <- as.data.frame(cbind(seq(0:29),t(data4plot[,109:138])))
colnames(pyr_age_ns) <- c("time",data4plot$conditions)

pyr_age_s <- as.data.frame(cbind(seq(0:29),t(data4plot[,139:168])))
colnames(pyr_age_s) <- c("time",data4plot$conditions)



sub_selec <- params %>% filter(compet==1e-04) %>% filter(compet2==1e-06) %>% select(conditions)



ggplot(pop_size, aes(x = time)) + 
  geom_line(aes(y=cond_1)) + 
  geom_line(aes(y=cond_5)) + 
  geom_line(aes(y=cond_8)) 


ggplot(Smurf_prop, aes(x = time)) + 
  geom_line(aes(y=cond_1)) + 
  geom_line(aes(y=cond_5)) + 
  geom_line(aes(y=cond_8)) 
