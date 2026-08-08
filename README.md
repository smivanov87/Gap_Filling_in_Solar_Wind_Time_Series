# Gap_Filling_in_Solar_Wind_Time_Series
MATLAB code accompanying the paper "Gap Filling in Solar Wind Time Series", submitted to RAS Techniques and Instruments.
**MATLAB Version**
The code was developed and tested using MATLAB R2024b.
Earlier MATLAB versions may also work, but compatibility has not been systematically tested. For reproducibility, MATLAB R2024b or a later compatible version is recommended.
**Data**
Two datasets are used in this repository:
**Hp60 Index**
The Hp60 geomagnetic index data were downloaded from the GFZ German Research Centre for Geosciences web service in 2025.
The data can be downloaded using:

websave('Hp60.txt', ...
    'https://kp.gfz.de/app/hpodata?startdate=1995-01-01&enddate=2025-06-02&format=Hp60_txt#hpo-data-download-207');

load Hp60.txt -ascii;

**OMNI Data**
The OMNI solar wind dataset was downloaded in 2025 from the OMNIWeb website. The downloaded file is named omni2_all_years.dat.
The data can be downloaded using:

url = 'https://spdf.gsfc.nasa.gov/pub/data/omni/low_res_omni/omni2_all_years.dat';
filename = 'omni2_all_years.dat';

websave(filename, url);

load omni2_all_years.dat -ascii;

The datasets are used for the analysis and evaluation of the gap-filling methods presented in this repository.

