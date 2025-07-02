#!/bin/bash

echo "[INFO] Loading modules..."
ml gcc/11.3.0

ulimit -s unlimited
export OMP_STACKSIZE=10485760

# Optional: Load or create a virtualenv
# python3 -m venv venv && source venv/bin/activate

echo "[INFO] Installing dftbridge..."
pip install --user dftbridge

# STEP 1: Find raw QE outputs
echo "[INFO] Searching for QE outputs..."
QE_FILES=$(find . -type f \( -name "*.out" -o -name "*.xml" \))

if [ -z "$QE_FILES" ]; then
  echo "[ERROR] No QE DFT output files found."
  exit 1
fi

# STEP 2: Run dftbridge for each QE output
for qe_file in $QE_FILES; do
  echo "[INFO] Converting $qe_file to LAMMPS dump format..."
  base=$(basename "$qe_file" .out)
  dump_file="${base}_lammps.dump"
  
  # Call your dftbridge CLI (adjust if needed)
  python3 -m dftbridge.convert "$qe_file" "$dump_file"
  
  if [ $? -ne 0 ]; then
    echo "[ERROR] dftbridge failed on $qe_file"
    exit 1
  fi
  echo "[SUCCESS] Created: $dump_file"
done

# Optional STEP 3: Replace filename in input file
# (Only works if y.input has a placeholder line like "structure_file = ..." or similar)
echo "[INFO] Updating y.input to reference latest dump file..."
# Assuming last converted file is the correct one
latest_dump=$(ls -t *_lammps.dump | head -n1)
sed -i "s|structure_file = .*|structure_file = $latest_dump|" y.input

# STEP 4: Run the fitting code
echo "[INFO] Running fitting executable..."
./nn_calib_gcc_new -in y.input
