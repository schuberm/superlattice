#!/bin/bash
cd $PBS_O_WORKDIR
module load openmpi-psm-gcc

RUNPATH=/home/jason/sam/20K/diffusion/4p_888/perfect
EXEPATH=/opt/mcgaugheygroup/matlab_R2011a/bin

mpirun -np `cat $PBS_NODEFILE | wc -l` $EXEPATH/matlab -nojvm -nosplash -nodisplay -r -nodesktop < $RUNPATH/gulp_master.m

