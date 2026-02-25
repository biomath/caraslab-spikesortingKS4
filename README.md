# CarasLab-SpikeSortingKS4

Pipeline for spike sorting multi-channel data acquired with TDT and Intan hardware.

Preprocessing steps convert data from native formats (Synapse or OpenEphysGUI) to .mat and/or .dat files. Files are then common median referenced and high-pass filtered, and run through Kilosort2 for sorting. 
This version requires a modified Kilosort4 file (present in this repository) to run. Instructions are below.

Modified run_kilosort.py: Needed to comment out a couple of plotting functions because MatLab pyenv crashed when matplotlib.pyplot was called. Something to do with Anaconda distribution?
TODO: Try to install Kilosort using a base python distribution

Required before running for the first time:
1. Install [npy-matlab](https://github.com/kwikteam/npy-matlab) and add to MatLab path
2. Install [open-ephys-matlab-tools](https://github.com/open-ephys/open-ephys-matlab-tools.git) and add to MatLab path
3. Kilosort4 v4.1.3: install Kilosort4 according to the developers' [instructions](https://github.com/MouseLand/Kilosort). Note: v4.1.3 is required.
   - Instead of steps 7-8 in the kilosort installation instructions, see below
4. Reinstalling torch within the kilosort environment seems to be a requirement for this to work.
  
        pip uninstall torch
        pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124

5. Copy the modified run_kilosort.py file into your conda path (e.g., /home/user/miniconda3/envs/kilosort/lib/python3.11/site-packages/kilosort)

6. Install phy acording to developers' [instructions](https://github.com/cortex-lab/phy)
   - Note: I prefer the phy2 development version:
      ```
      git clone git@github.com:cortex-lab/phy.git
      cd phy
      pip install -r requirements.txt
      pip install -r requirements-dev.txt
      pip install -e .
      cd ..
      git clone git@github.com:cortex-lab/phylib.git
      cd phylib
      pip install -e . --upgrade
      ```
