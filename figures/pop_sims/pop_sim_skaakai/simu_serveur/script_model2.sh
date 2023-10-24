#!/bin/bash

for birth_rate in  0.1 0.2 0.3 0.4
do
	for compet in 1e-6 1e-5 1e-4
	do
		for compet2 in 1e-7 1e-6
		do
			Rscript DiMeglio_Model2_exponential_transition_immigration_compet2smurf.R $birth_rate $compet $compet2 &
			echo 'Performing simulation with parameters:' $birth_rate $compet $compet2 "finished" &
		done
	done
done
