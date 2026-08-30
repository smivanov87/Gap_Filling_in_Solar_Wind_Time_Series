% Table1
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

% Statistical characteristics of time series V, Bx, By,Bz, N Intervals
% t1=find(Tdate(:)=='01-Jun-1965 00:00:00');
t1=find(Tdate(:)=='01-Jan-1963 00:00:00'); t2=find(Tdate(:)=='24-May-2025 00:00:00');
DistV=omni2_all_years(t1:t2, 25);
DistBx=omni2_all_years(t1:t2, 13);
DistBy=omni2_all_years(t1:t2, 16);
DistBz=omni2_all_years(t1:t2, 17);
DistN=omni2_all_years(t1:t2, 24);

[num2str(round(mean(DistV(find(DistV~=9999))), 0)),'&',num2str(round(mean(DistBx(find(DistBx~=999.9))), 2)),'&',num2str(round(mean(DistBy(find(DistBy~=999.9))), 2)),'&',num2str(round(mean(DistBz(find(DistBz~=999.9))), 2)),'&',num2str(round(mean(DistN(find(DistN~=999.9))), 1)), '\\']
[num2str(round(min(DistV(find(DistV~=9999))), 0)),'&',num2str(round(min(DistBx(find(DistBx~=999.9))), 2)),'&',num2str(round(min(DistBy(find(DistBy~=999.9))), 2)),'&',num2str(round(min(DistBz(find(DistBz~=999.9))), 2)),'&',num2str(round(min(DistN(find(DistN~=999.9))), 1)), '\\']
[num2str(round(max(DistV(find(DistV~=9999))), 0)),'&',num2str(round(max(DistBx(find(DistBx~=999.9))), 2)),'&',num2str(round(max(DistBy(find(DistBy~=999.9))), 2)),'&',num2str(round(max(DistBz(find(DistBz~=999.9))), 2)),'&',num2str(round(max(DistN(find(DistN~=999.9))), 1)), '\\']
[num2str(round(std(DistV(find(DistV~=9999)),1),1)),'&',num2str(round(std(DistBx(find(DistBx~=999.9)),1),1)),'&',num2str(round(std(DistBy(find(DistBy~=999.9)),1),2)),'&',num2str(round(std(DistBz(find(DistBz~=999.9)),1),1)),'&',num2str(round(std(DistN(find(DistN~=999.9)),1),1)),'\\']
[num2str(round(var(DistV(find(DistV~=9999)),1),1)),'&',num2str(round(var(DistBx(find(DistBx~=999.9)),1),1)),'&',num2str(round(var(DistBy(find(DistBy~=999.9)),1),2)),'&',num2str(round(var(DistBz(find(DistBz~=999.9)),1),1)),'&',num2str(round(var(DistN(find(DistN~=999.9)),1),1)),'\\']
[num2str(round(std(DistV(find(DistV~=9999)),1)/abs(mean(DistV(find(DistV~=9999))) ), 1)),'&',...
    num2str(round(std(DistBx(find(DistBx~=999.9)),1)/abs(mean(DistBx(find(DistBx~=999.9))) ), 1)),'&',...
    num2str(round(std(DistBy(find(DistBy~=999.9)),1)/abs(mean(DistBy(find(DistBy~=999.9))) ), 1)),'&',...
    num2str(round(std(DistBz(find(DistBz~=999.9)),1)/abs(mean(DistBz(find(DistBz~=999.9))) ), 1)),'&',...
    num2str(round(std(DistN(find(DistN~=999.9)),1)/abs(mean(DistN(find(DistN~=999.9))) ), 1)),'\\']
[num2str(round(skewness(DistV(find(DistV~=9999))),2)),'&',num2str(round(skewness(DistBx(find(DistBx~=999.9))),1)),'&',num2str(round(skewness(DistBy(find(DistBy~=999.9))),1)),'&',num2str(round(skewness(DistBz(find(DistBz~=999.9))),1)),'&',num2str(round(skewness(DistN(find(DistN~=999.9))),1)),'\\']
[num2str(round(kurtosis(DistV(find(DistV~=9999))),1)),'&',num2str(round(kurtosis(DistBx(find(DistBx~=999.9))),2)),'&',num2str(round(kurtosis(DistBy(find(DistBy~=999.9))),1)),'&',num2str(round(kurtosis(DistBz(find(DistBz~=999.9))),1)),'&',num2str(round(kurtosis(DistN(find(DistN~=999.9))),1)),'\\']

