% Figure 2.
% Data
% OMNI
OMNI_folder = fullfile(fileparts(pwd), 'Data');

if ~isfolder(OMNI_folder)
    % mkdir('Data');
    mkdir(OMNI_folder);
end

if ~isfile(fullfile(OMNI_folder, 'omni2_all_years.dat'))
url = 'https://spdf.gsfc.nasa.gov/pub/data/omni/low_res_omni/omni2_all_years.dat';
filename = strcat(OMNI_folder,'/omni2_all_years.dat');
websave(filename, url);
end
load(strcat(OMNI_folder, '/omni2_all_years.dat'), '-ascii');

Tdate=datetime(omni2_all_years(1:end,1),month(omni2_all_years(1:end,2)),day(omni2_all_years(1:end,2)),omni2_all_years(1:end,3),0,0  );
% % Hp60
% websave('Hp60.txt', 'https://kp.gfz.de/app/hpodata?startdate=1995-01-01&enddate=2025-06-02&format=Hp60_txt#hpo-data-download-207');
% load Hp60.txt -ascii;

t1=find(Tdate(:)=='01-Jun-1965 00:00:00'); 
t2=find(Tdate(:)=='24-May-2025 01:00:00'); 
k = find(omni2_all_years(t1:t2,25)~=9999); %all data
% function
[gaps] = gaps_stat(k);
[gapsBx] = gaps_stat(find(omni2_all_years(t1:t2,13)~=999.9));
[gapsBy] = gaps_stat(find(omni2_all_years(t1:t2,16)~=999.9));
[gapsBz] = gaps_stat(find(omni2_all_years(t1:t2,17)~=999.9));
[gapsN] = gaps_stat(find(omni2_all_years(t1:t2,24)~=999.9));

% different intervals
t1=find(Tdate(:)=='01-Jun-1965 00:00:00'); 
t2=find(Tdate(:)=='30-Dec-1994 23:00:00'); %no data for 31-Dec-1994
k1994 = find(omni2_all_years(t1:t2,25)~=9999); % length(Tdate(t1:t2))
k1994Bx = find(omni2_all_years(t1:t2,13)~=999.9); %Bx GSE, GSM 
k1994By = find(omni2_all_years(t1:t2,16)~=999.9); %By GSM
k1994Bz = find(omni2_all_years(t1:t2,17)~=999.9);  %Bz GSM
k1994N = find(omni2_all_years(t1:t2,24)~=999.9);  %Proton Density N/cm^3

t1=find(Tdate(:)=='01-Jan-1995 01:00:00'); 
t2=find(Tdate(:)=='24-May-2025 01:00:00'); 
k2025 = find(omni2_all_years(t1:t2,25)~=9999); %length(Tdate(t1:t2)) %V
k2025Bx = find(omni2_all_years(t1:t2,13)~=999.9); %Bx GSE, GSM 
k2025By = find(omni2_all_years(t1:t2,16)~=999.9); %By GSM
k2025Bz = find(omni2_all_years(t1:t2,17)~=999.9);  %Bz GSM
k2025N = find(omni2_all_years(t1:t2,24)~=999.9);  %Proton Density N/cm^3

[gaps2025] = gaps_stat(k2025);
[gaps2025Bx] = gaps_stat(k2025Bx);
[gaps2025By] = gaps_stat(k2025By);
[gaps2025Bz] = gaps_stat(k2025Bz);
[gaps2025N] = gaps_stat(k2025N);

% different intervals
[gaps1994] = gaps_stat(k1994);
[gaps1994Bx] = gaps_stat(k1994Bx);
[gaps1994By] = gaps_stat(k1994By);
[gaps1994Bz] = gaps_stat(k1994Bz);
[gaps1994N] = gaps_stat(k1994N);


%Different intervals
% % % % % % % % % % % % % 
[hp(1)] = gaps_fig2(gaps,gaps1994,gaps2025,'V_{SW} \quad [km \quad s^{-1}]',1,0); hp(1).Position = [0.1300    0.7093    0.7750    0.2700];
[hp(2)] = gaps_fig2(gapsBx,gaps1994Bx,gaps2025Bx,'(Bx,By,Bz) \quad GSM \quad [nT]',2,0); hp(2).Position = [0.1300    0.4096    0.7750    0.2700];
% [h3] = gaps_fig2(gapsBy,gaps1994By,gaps2025By,'By GSM')
% [h4] = gaps_fig2(gapsBz,gaps1994Bz,gaps2025Bz,'Bz GSM')
[hp(3)] = gaps_fig2(gapsN,gaps1994N,gaps2025N,'Density \quad [N \quad cm^{-3}]',3,1); hp(3).Position = [0.1300    0.1100    0.7750    0.2700];

