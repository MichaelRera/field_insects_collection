library(IBMPopSim)
library(ggplot2)

#update.packages(checkBuilt=TRUE, ask=FALSE)
#install.packages("Rcpp")
#install.packages("IBMPopSim")
#install.packages("devtools")
#install.packages("IRkernel")
#IRkernel::installspec()

par<- commandArgs(trailingOnly = TRUE)

N_init=1
pop_init <- data.frame("birth"=rep(0,N_init), "death"=rep(NA,N_init), "smurfness"=rep(0,N_init))
params <- list("birth_rate" = as.double(par[1]),
               "compet" = as.double(par[2]),
                "a" = 0.009,
               "t0" = 5.0,
               "k_int" = 0.1911,
				"compet2" = as.double(par[3]),
               "n_immig"= 9)

immig_event <- mk_event_poisson(name="immig1", type = "entry", 
    intensity = 'n_immig', 
    kernel_code = 'newI.set_age(CUnif(0,20),t);
                   newI.smurfness=0;')

death_event <- mk_event_individual(name = "death1", type = "death",
    intensity_code = 'if (I.smurfness==0)
            result = 0;
        else
            result = k_int;'
)

death_event2 <- mk_event_interaction(name = "death2", type = "death", 
    interaction_code = 'result = compet;'
)                                     

birth_event <- mk_event_individual(type="birth",
    intensity_code = 'if (I.smurfness==0)
            result = birth_rate;
        else
            result = birth_rate/15;',
    kernel_code = 'newI.smurfness=0;
                   newI.entry=0;'
)

swap_event <- mk_event_individual(
    type = "swap",
    intensity_code = 'if (I.smurfness==0){
                            if (age(I,t)==0)
                                result = 0;
                            else
                                result = (a*age(I,t)*exp(-t0/age(I,t)));
                            }
                        else
                            result = 0;',
    kernel_code = 'I.smurfness=1;'
)

swap_event2 <- mk_event_interaction(
    name = "swap2",
    type = "swap",
    interaction_code = 'if (I.smurfness==0){
                            result = compet2;
                        }
                        else
                            result = 0;',
    kernel_code = 'I.smurfness=1;'
)

model <- mk_model(
    characteristics = get_characteristics(pop_init),
    events = list(death_event, death_event2, swap_event, birth_event, immig_event, swap_event2),
    parameters = params,
    with_id = TRUE) #adds individuals IDs

summary(model)

death_max <- params$k_int
swap_max <- params$a*50*exp(-params$t0/50)

t_final =50
T = 0:t_final # Simulation end time 


sim_out <- popsim(model = model, age_max = 50,
  population = pop_init,
  events_bounds = c('death1'=death_max,'death2'=params$compet, 'swap'= swap_max, 'birth'= params$birth_rate, 'immig1'=params$n_immig, 'swap2'=params$compet2),
  parameters = params,
  time = T)

#mortality per age general pop
pop_final <- sim_out$population[[t_final]]
#Dx <- death_table(pop_final, 0:100, 0:100)
#Ex <- exposure_table(pop_final, 0:100, 0:100)
all_dead <- pop_final[is.na(pop_final$death)==FALSE,]
#dim(all_dead[all_dead$smurfness==1,])[1]/dim(all_dead)[1]

taux_smurf_alive<- function(i){pop= sim_out$population[[i]];
                                alive <- pop[is.na(pop$death),]
return(dim(alive[alive$smurfness==1,])[1]/dim(alive)[1]) }
nalive <- function(i){pop= sim_out$population[[i]];
                                alive <- pop[is.na(pop$death),]
return(dim(alive)[1]) }

vec_taux_smurf_alive<- sapply(1:t_final,function(i)(taux_smurf_alive(i)))
N_alive<- sapply(1:t_final,function(i)(nalive(i)))
                 length(N_alive)

pyr = age_pyramid(sim_out$population[[t_final]], time = t_final, ages=0:30)

data_output <- read.csv2("data_output_simu_model2.csv")

data_output[nrow(data_output)+1, ] <- c(params,N_alive,vec_taux_smurf_alive,pyr[,3])

write.table(data_output, "data_output_simu_model2.csv", row.names=FALSE, sep=";")


