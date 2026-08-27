Gap Reconstruction for Solar Wind Time Series
This repository contains MATLAB scripts and functions used for the reconstruction of gaps in solar-wind time series.
Getting started
The main entry point is the figure4.m script located in the Figure_4 folder.
The code was developed and tested using MATLAB R2024b.

To reproduce the gap-reconstruction procedure:

Download or clone this repository.
Open MATLAB R2024b.
Set the current folder to the Figure_4 folder containing figure4.m.
Run the script: figure4

The script automatically downloads the required data and software dependencies.
Automatic downloads
When figure4.m is run, it automatically:
Downloads the OMNI2 solar wind dataset from the NASA Space Physics Data Facility (SPDF).
Downloads the Singular Spectrum Analysis (SSA) MATLAB implementation from GitHub.
Creates the SSA folder and extracts the downloaded SSA files.
Creates the GapReconstruction folder.
Downloads the required gap reconstruction functions from this repository.
Extracts the required files and removes the downloaded ZIP archives.
Therefore, no manual installation of the SSA or gap reconstruction functions is required.
Running figure4.m reproduces Figure 4 presented in the article Gap Filling in Solar Wind Time Series.
