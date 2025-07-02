# run-sh

A bash script for converting Quantum ESPRESSO (QE) DFT outputs to LAMMPS dump format using dftbridge.

## Overview

This script automates the process of:
1. Finding Quantum ESPRESSO output files (`.out` and `.xml` files)
2. Converting them to LAMMPS dump format using dftbridge
3. Updating input files to reference the converted structure files
4. Running fitting executables

## Prerequisites

- GCC 11.3.0 (loaded via module system)
- Python 3 with pip
- dftbridge package
- LAMMPS fitting executable (`nn_calib_gcc_new`)

## Usage

1. Place your Quantum ESPRESSO output files in the current directory
2. Ensure you have an input file named `y.input` (optional)
3. Run the script:

```bash
chmod +x run.sh
./run.sh
```

## What the script does

1. **Loads required modules**: GCC 11.3.0
2. **Sets environment variables**: Unlimited stack size and OMP stack size
3. **Installs dftbridge**: Uses pip to install the conversion tool
4. **Finds QE outputs**: Searches for `.out` and `.xml` files
5. **Converts files**: Runs dftbridge on each QE output file
6. **Updates input file**: Modifies `y.input` to reference the latest dump file
7. **Runs fitting**: Executes the LAMMPS fitting program

## File Structure

- `run.sh` - Main conversion script
- `y.input` - Input file for the fitting executable (created/updated by script)
- `*_lammps.dump` - Generated LAMMPS dump files

## Requirements

- Module system (for loading GCC)
- Sufficient disk space for dump files
- Proper permissions to execute the fitting program 