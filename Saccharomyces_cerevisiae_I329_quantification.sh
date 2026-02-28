#!/usr/bin/env bash


#Saccharomyces cerevisiae I-329 Transcriptomics


#--------------------------------------


#Create the environment for trancriptomics

#Install NCBI SRA Toolkit for obtaining data (https://github.com/ncbi/sra-tools/wiki/01.-Downloading-SRA-Toolkit)
wget --output-document sratoolkit.tar.gz https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-ubuntu64.tar.gz
tar -vxzf sratoolkit.tar.gz

#Added the following path to ".bashrc"
# export PATH=$PWD/sratoolkit.3.0.0-mac64/bin:$PATH


conda create --name transcriptome
conda activate transcriptome

#Configure SRA toolkit
vdb-config -i


#--------------------------------------


#Download the NCBI transcriptomic data for Saccharomyces cerevisiae I-329:


#Early biofilms
prefetch SRR10551665 -O /home/cakbarally/binf6110/assignment_2/SRR10551665
fasterq-dump SRR10551665

prefetch SRR10551664 -O /home/cakbarally/binf6110/assignment_2/SRR10551664
fasterq-dump SRR10551664

prefetch SRR10551663 -O /home/cakbarally/binf6110/assignment_2/SRR10551663
fasterq-dump SRR10551663


#Thin biofilms
prefetch SRR10551662 -O /home/cakbarally/binf6110/assignment_2/SRR10551662
fasterq-dump SRR10551662

prefetch SRR10551661 -O /home/cakbarally/binf6110/assignment_2/SRR10551661
fasterq-dump SRR10551661

prefetch SRR10551660 -O /home/cakbarally/binf6110/assignment_2/SRR10551660
fasterq-dump SRR10551660


#Mature biofilms
prefetch SRR10551659 -O /home/cakbarally/binf6110/assignment_2/SRR10551659
fasterq-dump SRR10551659

prefetch SRR10551658 -O /home/cakbarally/binf6110/assignment_2/SRR10551658
fasterq-dump SRR10551658

prefetch SRR10551657 -O /home/cakbarally/binf6110/assignment_2/SRR10551657
fasterq-dump SRR10551657

#--------------------------------------


#Reference genome & Salmon indexing (v1.10.3)

wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/146/045/GCF_000146045.2_R64/GCF_000146045.2_R64_rna.fna.gz
gunzip GCF_000146045.2_R64_rna.fna.gz

salmon index -t GCF_000146045.2_R64_rna.fna -i Velum_index


#--------------------------------------


#Salmon quantification of biofilms (v1.10.3)


#Early biofilm
salmon quant -i Velum_index -l A -r SRR10551665.fastq -p 8 --validateMappings -o Velum_IL20_quant
salmon quant -i Velum_index -l A -r SRR10551664.fastq -p 8 --validateMappings -o Velum_IL21_quant
salmon quant -i Velum_index -l A -r SRR10551663.fastq -p 8 --validateMappings -o Velum_IL22_quant

#Thin biofilm
salmon quant -i Velum_index -l A -r SRR10551662.fastq -p 8 --validateMappings -o Velum_IL23_quant
salmon quant -i Velum_index -l A -r SRR10551661.fastq -p 8 --validateMappings -o Velum_IL24_quant
salmon quant -i Velum_index -l A -r SRR10551660.fastq -p 8 --validateMappings -o Velum_IL25_quant

#Mature biofilm
salmon quant -i Velum_index -l A -r SRR10551659.fastq -p 8 --validateMappings -o Velum_IL29_quant
salmon quant -i Velum_index -l A -r SRR10551658.fastq -p 8 --validateMappings -o Velum_IL30_quant
salmon quant -i Velum_index -l A -r SRR10551657.fastq -p 8 --validateMappings -o Velum_IL31_quant
