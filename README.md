# Gap_Filling_in_Solar_Wind_Time_Series
This repository contains the MATLAB code and supporting data used in the study “Gap Filling in Solar Wind Time Series”. The code provides the implementation used to investigate and evaluate methods for filling gaps in solar wind time series data.
##Requirements
The code was developed and tested using:
MATLAB R2024b
Earlier MATLAB versions may work, but compatibility has not been systematically tested.
For reproducibility, MATLAB R2024b or a later compatible version is recommended.
The Figure_* and Table* directories contain the MATLAB code and/or results associated with the corresponding figures and tables in the manuscript.

## Authors
[Serhii M. Ivanov](https://github.com/smivanov87)
[CMJ](https://github.com/caitrionajackman)
[ARF](https://github.com/arfogg)
[SJW](https://github.com/08walkersj) 

## Data
Two datasets are used in the analysis.

Hp60 geomagnetic index
The Hp60 geomagnetic index data were obtained from the GFZ German Research Centre for Geosciences in 2025.
The data cover the period from 1995-01-01 to 2025-06-02.

OMNI solar-wind data
The solar wind data are obtained from the NASA OMNIWeb/SPDF database.
The low-resolution OMNI dataset used in the analysis is: omni2_all_years.dat
The datasets are used for the analysis, testing, and evaluation of the gap-filling methods presented in the study.

## Running the Code
To reproduce the analysis:
Download or clone this repository.
Open MATLAB R2024b or a compatible later version.
Add the repository and its subdirectories to the MATLAB path, if required.
Download the required datasets as described above.
Place the downloaded data files in the appropriate data directory.
Run the MATLAB scripts associated with the desired figure or table.
For example, the directories Figure_1, Figure_2, etc., contain the code used to generate the corresponding figures, while Table1, Table2, etc., contain the code associated with the corresponding tables.

## Reproducibility
The repository is provided to facilitate reproducibility of the results presented in the associated study. The MATLAB scripts, together with the Hp60 and OMNI datasets, provide the basis for reproducing the analyses and evaluating the gap-filling methods.
Because the external datasets may be updated by their providers, the downloaded data may differ from the versions originally used in the study. 

## License
This project is distributed under the MIT License. See LICENSE for details.

## Contact
For questions regarding the code or methodology, please contact the author.

## Acknowledgements
[SMI's](https://github.com/smivanov87) and [SJW's](https://github.com/08walkersj) work at DIAS was supported by Taighde Éireann - Research Ireland award 18/FRL/6199 (S2)) to [CMJ](https://github.com/caitrionajackman) which includes an extension to fund Displaced Researchers.
[ARF's](https://github.com/arfogg) work at DIAS was supported by Taighde Éireann - Research Ireland Laureate Consolidator award SOLMEX to [CMJ](https://github.com/caitrionajackman).
The authors have no conflicts of interest to disclose.

## Citation
Ivanov, S. M., Jackman, C. M., Fogg, A. R., & Walker, S. J. (2026). Gap Filling in Solar Wind Time Series (Version v1.0.0) [Computer software]. Zenodo. https://doi.org/10.5281/zenodo.22181986 
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.22181986.svg)](https://doi.org/10.5281/zenodo.22181986)

