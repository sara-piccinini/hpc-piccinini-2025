#!/bin/bash
#SBATCH --job-name=systolic_sweep
#SBATCH --time=00:20:00
#SBATCH --ntasks=4
#SBATCH --partition=global
#SBATCH --output=/home/hpc_2025_group_01/sara/sbatch_results/out_%j.txt
#SBATCH --error=/home/hpc_2025_group_01/sara/sbatch_results/err_%j.txt
#SBATCH --mail-type=END
#SBATCH --mail-user=s347092@studenti.polito.it

cd $TMPDIR

# Copy executable and input matrices
cp /home/hpc_2025_group_01/sara/systolic_matrix_mult .
chmod +x systolic_matrix_mult

cp /home/hpc_2025_group_01/sara/input_matrices/A_2000.csv A.csv
cp /home/hpc_2025_group_01/sara/input_matrices/B_2000.csv B.csv

MPIRUN=/opt/ohpc/pub/mpi/openmpi3-gnu8/3.1.4/bin/mpirun

for NP in 1 2 4
do
    echo "Running with $NP MPI processes..."
    rm -f timing_results.txt C_out.csv

    $MPIRUN -np $NP ./systolic_matrix_mult A.csv B.csv 2000

    cp timing_results.txt /home/hpc_2025_group_01/sara/sbatch_results/timing_N2000_np${NP}_$SLURM_JOB_ID.txt
    cp C_out.csv /home/hpc_2025_group_01/sara/sbatch_results/C_out_N2000_np${NP}_$SLURM_JOB_ID.csv
done

