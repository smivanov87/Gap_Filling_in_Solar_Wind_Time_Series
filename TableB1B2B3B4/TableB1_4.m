% 
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


% t2=find(Tdate(:)=='24-May-2025 01:00:00');
% 
% omni2_all_years=omni2_all_years(1:t2,:);
% Tdate=datetime(omni2_all_years(1:end,1),month(omni2_all_years(1:end,2)),day(omni2_all_years(1:end,2)),omni2_all_years(1:end,3),0,0  );


% 
t1=find(Tdate(:)=='01-Jun-1965 00:00:00'); 
t2=find(Tdate(:)=='30-Dec-1994 23:00:00'); %no data for 31-Dec-1994
k1994 = find(omni2_all_years(t1:t2,25)~=9999); length(Tdate(t1:t2))
k1994Bx = find(omni2_all_years(t1:t2,13)~=999.9); %Bx GSE, GSM 
k1994By = find(omni2_all_years(t1:t2,16)~=999.9); %By GSM
k1994Bz = find(omni2_all_years(t1:t2,17)~=999.9);  %Bz GSM
k1994N = find(omni2_all_years(t1:t2,24)~=999.9);  %Proton Density N/cm^3

t1=find(Tdate(:)=='01-Jan-1995 01:00:00'); 
t2=find(Tdate(:)=='24-May-2025 02:00:00'); 
k2025 = find(omni2_all_years(t1:t2,25)~=9999); length(Tdate(t1:t2))
k2025Bx = find(omni2_all_years(t1:t2,13)~=999.9); %Bx GSE, GSM 
k2025By = find(omni2_all_years(t1:t2,16)~=999.9); %By GSM
k2025Bz = find(omni2_all_years(t1:t2,17)~=999.9);  %Bz GSM
k2025N = find(omni2_all_years(t1:t2,24)~=999.9);  %Proton Density N/cm^3

t1=find(Tdate(:)=='01-Jun-1965 00:00:00'); 
t2=find(Tdate(:)=='24-May-2025 02:00:00'); 
k = find(omni2_all_years(t1:t2,25)~=9999); %all data

% 
[gaps] = gaps_stat(k);
[gapsBx] = gaps_stat(find(omni2_all_years(t1:t2,13)~=999.9));
[gapsBy] = gaps_stat(find(omni2_all_years(t1:t2,16)~=999.9));
[gapsBz] = gaps_stat(find(omni2_all_years(t1:t2,17)~=999.9));
[gapsN] = gaps_stat(find(omni2_all_years(t1:t2,24)~=999.9));

% different intervals
[gaps1994] = gaps_stat(k1994);
[gaps1994Bx] = gaps_stat(k1994Bx);
[gaps1994By] = gaps_stat(k1994By);
[gaps1994Bz] = gaps_stat(k1994Bz);
[gaps1994N] = gaps_stat(k1994N);

[gaps2025] = gaps_stat(k2025);
[gaps2025Bx] = gaps_stat(k2025Bx);
[gaps2025By] = gaps_stat(k2025By);
[gaps2025Bz] = gaps_stat(k2025Bz);
[gaps2025N] = gaps_stat(k2025N);

% B2
% Different intervals
B2={[num2str(round( mean(gaps(:,1)),0 )), '&', num2str(round( mean(gaps1994(:,1)),0 )) , '&',num2str(round( mean(gaps2025(:,1)),0 )) ...
, '&',num2str(round( mean(gapsBx(:,1)),0 )) , '&',num2str(round( mean(gaps1994Bx(:,1)),0 )), '&', num2str(round( mean(gaps2025Bx(:,1)),0 )) ...
, '&',num2str(round( mean(gapsN(:,1)),0 )) , '&',num2str(round( mean(gaps1994N(:,1)),0 )) , '&',num2str(round( mean(gaps2025N(:,1)),0 )), '\\']

[num2str(round(std(gaps(:,1),1),0)), '&', num2str(round(std(gaps1994(:,1),1),0)),'&',num2str(round(std(gaps2025(:,1),1),0)) ...
, '&',num2str(round(std(gapsBx(:,1),1),0)) , '&',num2str(round(std(gaps1994Bx(:,1),1),0)), '&', num2str(round(std(gaps2025Bx(:,1),1),0)) ...
, '&',num2str(round(std(gapsN(:,1),1),0)) , '&',num2str(round(std(gaps1994N(:,1),1),0)), '&',num2str(round(std(gaps2025N(:,1),1),0)) , '\\'] 

[num2str(round( sqrt(var(gaps(:,1),1))/abs(mean(gaps(:,1) ) ) ,1 )) , '&',num2str(round( sqrt(var(gaps1994(:,1),1))/abs(mean(gaps1994(:,1) ) ) ,1 )) , '&',num2str(round( sqrt(var(gaps2025(:,1),1))/abs(mean(gaps2025(:,1) ) ) ,1 )) ...
, '&',num2str(round( sqrt(var(gapsBx(:,1),1))/abs(mean(gapsBx(:,1) ) ) ,1 )) , '&',num2str(round( sqrt(var(gaps1994Bx(:,1),1))/abs(mean(gaps1994Bx(:,1) ) ) ,1 )), '&',num2str(round( sqrt(var(gaps2025Bx(:,1),1))/abs(mean(gaps2025Bx(:,1) ) ) ,1 )) ...
, '&',num2str(round( sqrt(var(gapsN(:,1),1))/abs(mean(gapsN(:,1) ) ) ,1 )) , '&',num2str(round( sqrt(var(gaps1994N(:,1),1))/abs(mean(gaps1994N(:,1) ) ) ,1 )) ,'&',num2str(round( sqrt(var(gaps2025N(:,1),1))/abs(mean(gaps2025N(:,1) ) ) ,1 )) , '\\'] 

[num2str(round(skewness(gaps(:,1)),1)) , '&',num2str(round(skewness(gaps1994(:,1)),1)), '&',num2str(round(skewness(gaps2025(:,1)),1)) ...
, '&',num2str(round(skewness(gapsBx(:,1)),1)) , '&', num2str(round(skewness(gaps1994Bx(:,1)),1)), '&',num2str(round(skewness(gaps2025Bx(:,1)),1)) ...
, '&',num2str(round(skewness(gapsN(:,1)),1)) , '&', num2str(round(skewness(gaps1994N(:,1)),1)), '&',num2str(round(skewness(gaps2025N(:,1)),1)) , '\\'] 

[num2str(round(kurtosis(gaps(:,1)),0))  , '&',num2str(round(kurtosis(gaps1994(:,1)),0)), '&',num2str(round(kurtosis(gaps2025(:,1)),1))...
, '&',num2str(round(kurtosis(gapsBx(:,1)),0)) , '&', num2str(round(kurtosis(gaps1994Bx(:,1)),0)), '&',num2str(round(kurtosis(gaps2025Bx(:,1)),1))...
, '&',num2str(round(kurtosis(gapsN(:,1)),0))  , '&',num2str(round(kurtosis(gaps1994N(:,1)),0)), '&',num2str(round(kurtosis(gaps2025N(:,1)),1)), '\\'] 
}


% B4
ans=[];
Dgaps=tabulate(gaps(:,4));          
Dgaps1994=tabulate(gaps1994(:,4)); %Different intervals
Dgaps2025=tabulate(gaps2025(:,4)); 
% [num2str(Dgaps(:,1)) repmat('&',25,1) num2str(Dgaps(:,2)) repmat('&',25,1) num2str(Dgaps1994(:,2)) repmat('&',25,1) num2str(Dgaps2025(:,2))]; %V
% [num2str(Dgaps(:,1)) repmat('&',25,1) num2str(round(Dgaps(:,2)*100/525770,3)) repmat('&',25,1) num2str(round(Dgaps1994(:,2)*100/259320,3)) repmat('&',25,1) num2str(round(Dgaps2025(:,2)*100/266450,3))]; %V
[num2str(Dgaps(:,1)) repmat('&',25,1) num2str(round(Dgaps(:,2)*10000/525770,0)) repmat('&',25,1) num2str(round(Dgaps1994(:,2)*1000/259320,0)) repmat('&',25,1) num2str(round(Dgaps2025(:,2)*100000/266450,0))]; %V the number of gaps at the interval

Dgaps=tabulate(gapsBx(:,4));          
Dgaps1994=tabulate(gaps1994Bx(:,4)); %Different intervals
Dgaps2025=tabulate(gaps2025Bx(:,4)); 
% ans=[ans repmat('&',25,1) num2str(Dgaps(:,2)) repmat('&',25,1) num2str(Dgaps1994(:,2)) repmat('&',25,1) num2str(Dgaps2025(:,2))]; %Bx
% ans=[ans repmat('&',25,1) num2str(round(Dgaps(:,2)*100/525770,3)) repmat('&',25,1) num2str(round(Dgaps1994(:,2)*100/259320,3)) repmat('&',25,1) num2str(round(Dgaps2025(:,2)*100/266450,3))]; %Bx
ans=[ans repmat('&',25,1) num2str(round(Dgaps(:,2)*10000/525770,0)) repmat('&',25,1) num2str(round(Dgaps1994(:,2)*1000/259320,0)) repmat('&',25,1) num2str(round(Dgaps2025(:,2)*100000/266450,0))]; %Bx

Dgaps=tabulate(gapsN(:,4));          
Dgaps1994=tabulate(gaps1994N(:,4)); %Different intervals
Dgaps2025=tabulate(gaps2025N(:,4)); 
% ans=[ans repmat('&',25,1) num2str(Dgaps(:,2)) repmat('&',25,1) num2str(Dgaps1994(:,2)) repmat('&',25,1) num2str(Dgaps2025(:,2)) repmat('\\',25,1) ]; %N
% ans=[ans repmat('&',25,1) num2str(round(Dgaps(:,2)*100/525770,3)) repmat('&',25,1) num2str(round(Dgaps1994(:,2)*100/259320,3)) repmat('&',25,1) num2str(round(Dgaps2025(:,2)*100/266450,3)) repmat('\\',25,1) ]; %N
ans=[ans repmat('&',25,1) num2str(round(Dgaps(:,2)*10000/525770)) repmat('&',25,1) num2str(round(Dgaps1994(:,2)*1000/259320)) repmat('&',25,1) num2str(round(Dgaps2025(:,2)*100000/266450)) repmat('\\',25,1) ]; %N
B4=ans;


% B1
ans=[];
Dgaps=tabulate(gaps(:,4));          
Dgaps1994=tabulate(gaps1994(:,4)); %Different intervals
Dgaps2025=tabulate(gaps2025(:,4)); 
[num2str(Dgaps(:,1)) repmat('&',25,1) num2str(Dgaps(:,2)) repmat('&',25,1) num2str(Dgaps1994(:,2)) repmat('&',25,1) num2str(Dgaps2025(:,2))]; %V
% [num2str(Dgaps(:,1)) repmat('&',25,1) num2str(round(Dgaps(:,2)*100/525770,3)) repmat('&',25,1) num2str(round(Dgaps1994(:,2)*100/259320,3)) repmat('&',25,1) num2str(round(Dgaps2025(:,2)*100/266450,3))]; %V
% [num2str(Dgaps(:,1)) repmat('&',25,1) num2str(round(Dgaps(:,2)*10000/525770,0)) repmat('&',25,1) num2str(round(Dgaps1994(:,2)*1000/259320,0)) repmat('&',25,1) num2str(round(Dgaps2025(:,2)*100000/266450,0))]; %V the number of gaps at the interval

Dgaps=tabulate(gapsBx(:,4));          
Dgaps1994=tabulate(gaps1994Bx(:,4)); %Different intervals
Dgaps2025=tabulate(gaps2025Bx(:,4)); 
ans=[ans repmat('&',25,1) num2str(Dgaps(:,2)) repmat('&',25,1) num2str(Dgaps1994(:,2)) repmat('&',25,1) num2str(Dgaps2025(:,2))]; %Bx
% ans=[ans repmat('&',25,1) num2str(round(Dgaps(:,2)*100/525770,3)) repmat('&',25,1) num2str(round(Dgaps1994(:,2)*100/259320,3)) repmat('&',25,1) num2str(round(Dgaps2025(:,2)*100/266450,3))]; %Bx
% ans=[ans repmat('&',25,1) num2str(round(Dgaps(:,2)*10000/525770,0)) repmat('&',25,1) num2str(round(Dgaps1994(:,2)*1000/259320,0)) repmat('&',25,1) num2str(round(Dgaps2025(:,2)*100000/266450,0))]; %Bx

Dgaps=tabulate(gapsN(:,4));          
Dgaps1994=tabulate(gaps1994N(:,4)); %Different intervals
Dgaps2025=tabulate(gaps2025N(:,4)); 
ans=[ans repmat('&',25,1) num2str(Dgaps(:,2)) repmat('&',25,1) num2str(Dgaps1994(:,2)) repmat('&',25,1) num2str(Dgaps2025(:,2)) repmat('\\',25,1) ]; %N
% ans=[ans repmat('&',25,1) num2str(round(Dgaps(:,2)*100/525770,3)) repmat('&',25,1) num2str(round(Dgaps1994(:,2)*100/259320,3)) repmat('&',25,1) num2str(round(Dgaps2025(:,2)*100/266450,3)) repmat('\\',25,1) ]; %N
% ans=[ans repmat('&',25,1) num2str(round(Dgaps(:,2)*10000/525770)) repmat('&',25,1) num2str(round(Dgaps1994(:,2)*1000/259320)) repmat('&',25,1) num2str(round(Dgaps2025(:,2)*100000/266450)) repmat('\\',25,1) ]; %N
B1=ans;


% B3
ans=[];
Dgaps=tabulate(gaps(:,4));          
Dgaps1994=tabulate(gaps1994(:,4)); %Different intervals
Dgaps2025=tabulate(gaps2025(:,4)); 
% [num2str(Dgaps(:,1)) repmat('&',25,1) num2str(Dgaps(:,2)) repmat('&',25,1) num2str(Dgaps1994(:,2)) repmat('&',25,1) num2str(Dgaps2025(:,2))]; %V
[num2str(Dgaps(:,1)) repmat('&',25,1) num2str(round(Dgaps(:,2)*100/525770,3)) repmat('&',25,1) num2str(round(Dgaps1994(:,2)*100/259320,3)) repmat('&',25,1) num2str(round(Dgaps2025(:,2)*100/266450,3))]; %V
% [num2str(Dgaps(:,1)) repmat('&',25,1) num2str(round(Dgaps(:,2)*10000/525770,0)) repmat('&',25,1) num2str(round(Dgaps1994(:,2)*1000/259320,0)) repmat('&',25,1) num2str(round(Dgaps2025(:,2)*100000/266450,0))]; %V the number of gaps at the interval

Dgaps=tabulate(gapsBx(:,4));          
Dgaps1994=tabulate(gaps1994Bx(:,4)); %Different intervals
Dgaps2025=tabulate(gaps2025Bx(:,4)); 
% ans=[ans repmat('&',25,1) num2str(Dgaps(:,2)) repmat('&',25,1) num2str(Dgaps1994(:,2)) repmat('&',25,1) num2str(Dgaps2025(:,2))]; %Bx
ans=[ans repmat('&',25,1) num2str(round(Dgaps(:,2)*100/525770,3)) repmat('&',25,1) num2str(round(Dgaps1994(:,2)*100/259320,3)) repmat('&',25,1) num2str(round(Dgaps2025(:,2)*100/266450,3))]; %Bx
% ans=[ans repmat('&',25,1) num2str(round(Dgaps(:,2)*10000/525770,0)) repmat('&',25,1) num2str(round(Dgaps1994(:,2)*1000/259320,0)) repmat('&',25,1) num2str(round(Dgaps2025(:,2)*100000/266450,0))]; %Bx

Dgaps=tabulate(gapsN(:,4));          
Dgaps1994=tabulate(gaps1994N(:,4)); %Different intervals
Dgaps2025=tabulate(gaps2025N(:,4)); 
% ans=[ans repmat('&',25,1) num2str(Dgaps(:,2)) repmat('&',25,1) num2str(Dgaps1994(:,2)) repmat('&',25,1) num2str(Dgaps2025(:,2)) repmat('\\',25,1) ]; %N
ans=[ans repmat('&',25,1) num2str(round(Dgaps(:,2)*100/525770,3)) repmat('&',25,1) num2str(round(Dgaps1994(:,2)*100/259320,3)) repmat('&',25,1) num2str(round(Dgaps2025(:,2)*100/266450,3)) repmat('\\',25,1) ]; %N
% ans=[ans repmat('&',25,1) num2str(round(Dgaps(:,2)*10000/525770)) repmat('&',25,1) num2str(round(Dgaps1994(:,2)*1000/259320)) repmat('&',25,1) num2str(round(Dgaps2025(:,2)*100000/266450)) repmat('\\',25,1) ]; %N
B3=ans;

disp(B1)
disp(B2)
disp(B3)
disp(B4)