#creating conda env

conda create --name SBG383_env python jupyter

#deleting env
conda env remove --name myenv

#activating conda env

conda activate SBG383_env

#installing jupyter lab

conda install -c conda-forge jupyterlab

#Create a bash script called hello.sh that takes a command line input of name, bash hello.sh Jane, prints:

#Hello Jane.
#How are you?

#!/bin/bash

echo "Hello $1."
echo "How are you?"

#Outline the steps you would take to create a reproducible project structure, and the corresponding commands you would use. 

#1 Formulating a hypothesis
#2 Designing the study
#3 Running the study and collecting the data
#4 Analysing the data
#5 Reporting the study

#!/bin/bash

echo "Items downloaded: " 
ls ../Data/escherichia_coli_b_str_rel606/ | wc -l 

echo "Unziping all files at once"
gunzip -v ../Data/escherichia_coli_b_str_rel606/*.gz 

echo "files in fasta format"
ls ../Data/escherichia_coli_b_str_rel606/ | grep -c '.fa'


#!/bin/bash

for i in `ls ../Data/escherichia_coli_b_str_rel606/*.fa`

do 
    echo "$i"   
    echo "A: `less "$i" | grep -v ">" | tr -d cCgGtTnN"\n" | wc -c` C: `less "$i" | grep -v ">" | tr -d aAgGtTnN"\n" | wc -c` G: `less "$i" | grep -v ">" | tr -d aAcCtTnN"\n" | wc -c` T: `less "$i" | grep -v ">" | tr -d aAcCgGnN"\n" | wc -c` N: `less "$i" | grep -v ">" | tr -d aAcCgGtT"\n" | wc -c`"
done


