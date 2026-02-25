# CarasLab-SpikeSortingKS4

Pipeline for spike sorting multi-channel data acquired with TDT and Intan hardware.

Preprocessing steps convert data from native formats (Synapse or OpenEphysGUI) to .mat and/or .dat files. Files are then common median referenced and high-pass filtered, and run through Kilosort2 for sorting. 
This version requires a modified Kilosort4 file (present in this repository) to run. Instructions are below.

Modified run_kilosort.py: Needed to comment out a couple of plotting functions because MatLab pyenv crashed when matplotlib.pyplot was called. Something to do with Anaconda distribution?
TODO: Try to install Kilosort using a base python distribution

Required before running for the first time:
1. npy-matlab (https://github.com/kwikteam/npy-matlab)
2. Kilosort4 v4.0.37: install Kilosort4 according to the developers' instructions (steps 1-6) (https://github.com/MouseLand/Kilosort/releases/tag/v4.0.37).
   - Instead of steps 7-8 in the kilosort installation instructions, see below
4. Reinstalling torch within the kilosort environment seems to be a requirement for this to work.
  
        pip uninstall torch
        pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124

5. Copy the modified run_kilosort.py file into your conda path (e.g., /home/user/miniconda3/envs/kilosort/lib/python3.9/site-packages/kilosort)
