% % SpaceCrafts
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
% load omni2_all_years.dat -ascii;
Tdate=datetime(omni2_all_years(1:end,1),month(omni2_all_years(1:end,2)),day(omni2_all_years(1:end,2)),omni2_all_years(1:end,3),0,0  );


t2=find(Tdate(:)=='24-May-2025 00:00:00');
omni2_all_years=omni2_all_years(1:t2,:);
Tdate=datetime(omni2_all_years(1:end,1),month(omni2_all_years(1:end,2)),day(omni2_all_years(1:end,2)),omni2_all_years(1:end,3),0,0  );

SP=""; %IMF spacecraft 
sp1=find(omni2_all_years(:,5)~=99);
spn1=unique(omni2_all_years(sp1,5),'stable');
for i=1:length(spn1)
spi=find(omni2_all_years(:,5)==spn1(i));
SP(i,1:3)=[num2str(spn1(i)), string(datetime(Tdate(min(spi) ),"Format",'dd-MM-yyyy')), string(datetime(Tdate(max(spi)),"Format",'dd-MM-yyyy'))];
end
SP = array2table(SP,'VariableNames', {'ID','Tst','Ted'});
SP2="";% SW plasma spacecraft 
sp2=find(omni2_all_years(:,6)~=99);
spn2=unique(omni2_all_years(sp2,6),'stable');
for i=1:length(spn2)
spi2=find(omni2_all_years(:,6)==spn2(i));
SP2(i,1:3)=[num2str(spn2(i)), string(datetime(Tdate(min(spi2) ),"Format",'dd-MM-yyyy')), string(datetime(Tdate(max(spi2)),"Format",'dd-MM-yyyy'))];
end
SP2 = array2table(SP2,'VariableNames', {'ID','Tst','Ted'}); 
% SP2(find(ismember(SP2.ID, {'52', '45','47'})),:)=[]; % the same as 51 and 52

Spacecraft_Name={'IMP 1 (Explorer 18)';
       'IMP 3 (Explorer 28)';
       'IMP 4 (Explorer 34)';
       'IMP 5 (Explorer 41)';
       'IMP 6 (Explorer 43)';
       'IMP 7 (Explorer 47)';
       'IMP 7 (Explorer 47)';
       'IMP 8 (Explorer 50)';
       'IMP 8 (Explorer 50)';
       'AIMP 1 (Explorer 33)';
       'AIMP 2 (Explorer 35)';
       'HEOS 1 and HEOS 2';
       'VELA 3';
       'OGO 5';
       'Merged LANL VELA Speed Data (July 1964 - March 1971)';
       'Merged LANL IMP T,N,V (Including all IMP 8 LANL Plasma)';
       'ISEE 1';
       'ISEE 2';
       'ISEE 3';
       'PROGNOZ 10';
       'WIND';
       'ACE';
       'Geotail';
       'No spacecraft'};
Spacecraft_ID={'18';
       '28';
       '34';
       '41'; 
       '43';
       '47 MAG and Plasma/MIT';
       '44 Plasma/LANL';
       '50 MAG and Plasma/MIT';
       '45 Plasma/LANL';
       '33';    
       '35';   
       '1';
       '3';
       '5';
       '97';
       '98';
       '11';
       '12';
       '13';
       '10';
       '51 -mag, plasma_KP; 52-Plasma_definitive';
       '71'; 
       '60';
       '99' };
ID=[18;28;34;41;43;47;44;50;45;33;35;1;3;5;97;98;11;12;13;10;51;71;60;99];
Spacecraft_Name2={'IMP 1';
       'IMP 3';
       'IMP 4';
       'IMP 5';
       'IMP 6';
       'IMP 7';
       'IMP 7';
       'IMP 8';
       'IMP 8';
       'AIMP 1';
       'AIMP 2';
       'HEOS 1 and HEOS 2';
       'VELA 3';
       'OGO 5';
       'LANL VELA';
       'LANL IMP T,N,V';
       'ISEE 1';
       'ISEE 2';
       'ISEE 3';
       'PROGNOZ 10';
       'WIND';
       'ACE';
       'Geotail';
       'No spacecraft'};
SPACECRAFT_IDENTIFIERS=table(ID,Spacecraft_ID, Spacecraft_Name,Spacecraft_Name2);
% save('SPACECRAFT_IDENTIFIERS.mat', 'SPACECRAFT_IDENTIFIERS');
% load SPACECRAFT_IDENTIFIERS.mat;
SP = innerjoin(SP,SPACECRAFT_IDENTIFIERS,'Keys','ID');
SP2=innerjoin(SP2,SPACECRAFT_IDENTIFIERS,'Keys','ID');

% IMF
SP.Tst_date = datetime(SP.Tst, 'InputFormat', 'dd-MM-yyyy');
SP = sortrows(SP, 'Tst_date', 'ascend'); SP.Tst_date = [];
[SP.ID SP.Spacecraft_Name SP.Tst SP.Ted]

% SW Plasma
SP2.Tst_date = datetime(SP2.Tst, 'InputFormat', 'dd-MM-yyyy');
SP2 = sortrows(SP2, 'Tst_date', 'ascend'); SP2.Tst_date = [];
[SP2.ID SP2.Spacecraft_Name SP2.Tst SP2.Ted ]
