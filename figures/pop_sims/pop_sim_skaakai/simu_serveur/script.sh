#!/bin/bash

for birth_rate in 0.1 
do
	for compet in 1e-6
	do
		
		Rscript model_attempt2_exponential_transition_immigration_SimuServeur.R $birth_rate $compet &
		echo 'Performing simulation with parameters:' $birth_rate $compet "finished" &
	done
done