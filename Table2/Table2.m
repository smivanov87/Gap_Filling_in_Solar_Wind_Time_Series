% Table2
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


% t2=find(Tdate(:)=='24-May-2025 00:00:00');
t2=find(Tdate(:)=='31-Jan-2018 00:00:00');
omni2_all_years=omni2_all_years(1:t2,:);
% Tdate=datetime(omni2_all_years(1:end,1),month(omni2_all_years(1:end,2)),day(omni2_all_years(1:end,2)),omni2_all_years(1:end,3),0,0  );

% % % % % % % % % % % % % % % % % % 
% Interval with similar properties
% % % % % % % % % % % % % % % % % % 
% V
MtsM=433; %Mean
MtsMin=156;
MtsMax=1189;
MtsStd=101; %std
MtsS=1; %skewness
MtsK=3.9; %kurtosis

MN=1000; % Interval Length
k=find(omni2_all_years(:,25)~=9999);
Mts=omni2_all_years(find(omni2_all_years(:,25)~=9999),25); %V excluding gaps
% Mts=omni2_all_years(:,25); %V
TdateV=Tdate(find(omni2_all_years(:,25)~=9999)); %V excluding gaps
% TdateV=Tdate; %V

% floor(length(Mts)/MN)*
MtsN=[];
MtsStat=[];
for i=1:(length(Mts)-MN)
     if k(i)+999==k(MN+i-1)
    MtsN(1:MN,i)=Mts(i:MN+i-1,1);
    MtsStat(1,i)=mean(MtsN(:,i));
    MtsStat(2,i)=min(MtsN(:,i));
    MtsStat(3,i)=max(MtsN(:,i));
    MtsStat(4,i)=std(MtsN(:,i),1);
    MtsStat(5,i)=skewness(MtsN(:,i));
    MtsStat(6,i)=kurtosis(MtsN(:,i));
     end
end


Mk=abs(MtsM-MtsStat(1,:))/sum(abs(MtsM-MtsStat(1,:)))+...
  abs(MtsStd-MtsStat(4,:))/sum(abs(MtsStd-MtsStat(4,:)))+...
abs(MtsMin-MtsStat(2,:))/sum(abs(MtsMin-MtsStat(2,:)))+...
abs(MtsMax-MtsStat(3,:))/sum(abs(MtsMax-MtsStat(3,:)))+...
abs(MtsS-MtsStat(5,:))/sum(abs(MtsS-MtsStat(5,:)))+...
abs(MtsK-MtsStat(6,:))/sum(abs(MtsK-MtsStat(6,:)));

f = [Mk];
intcon = 1:length(MtsN);
A = []; %[eye(length(Mts)-MN)];
bp = []; %[1];
% bp = [5; 2; 5; 2; -1];
Aeq = [ones(1,length(MtsN) )];
beq = [1];
% repmat(mean(Dst(:,1)),length(Dst),1)-Dst(:,1);
lb = zeros(length(MtsN),1);
ub = []; %ones((length(Mts)-MN),1);
x0=[];
% x0 = ones(1,(length(Mts)-MN));
% randi([0 1],1,length(Dst) );
options = optimoptions("intlinprog",MaxTime=120);
x = intlinprog(f,intcon,A,bp,Aeq,beq,lb,ub,x0,options);

T=["Vsw";string(TdateV(x>0),'dd.MM.yyyy');
string(TdateV(find(x>0)+999),'dd.MM.yyyy');
string(round(MtsStat(:,x>0),2)) ];

% Bx
MtsM=0.03; %Mean
MtsMin=-40.8;
MtsMax=34.8;
MtsStd=3.7; %std
MtsS=-0.1; %skewness
MtsK=4.03; %kurtosis

MN=1000; % Interval Length
k=find(omni2_all_years(:,13)~=999.9);
Mts=omni2_all_years(find(omni2_all_years(:,13)~=999.9),13); %Bx
TdateBx=Tdate(find(omni2_all_years(:,13)~=999.9));

% floor(length(Mts)/MN)*
MtsN=[];
MtsStat=[];
for i=1:(length(Mts)-MN)
     if k(i)+999==k(MN+i-1)
    MtsN(1:MN,i)=Mts(i:MN+i-1,1);
    MtsStat(1,i)=mean(MtsN(:,i));
    MtsStat(2,i)=min(MtsN(:,i));
    MtsStat(3,i)=max(MtsN(:,i));
    MtsStat(4,i)=std(MtsN(:,i),1);
    MtsStat(5,i)=skewness(MtsN(:,i));
    MtsStat(6,i)=kurtosis(MtsN(:,i));
     end
end


Mk=abs(MtsM-MtsStat(1,:))/sum(abs(MtsM-MtsStat(1,:)))+...
  abs(MtsStd-MtsStat(4,:))/sum(abs(MtsStd-MtsStat(4,:)))+...
abs(MtsMin-MtsStat(2,:))/sum(abs(MtsMin-MtsStat(2,:)))+...
abs(MtsMax-MtsStat(3,:))/sum(abs(MtsMax-MtsStat(3,:)))+...
abs(MtsS-MtsStat(5,:))/sum(abs(MtsS-MtsStat(5,:)))+...
abs(MtsK-MtsStat(6,:))/sum(abs(MtsK-MtsStat(6,:)));

f = [Mk];
intcon = 1:length(MtsN);
A = []; %[eye(length(Mts)-MN)];
bp = []; %[1];
% bp = [5; 2; 5; 2; -1];
Aeq = [ones(1,length(MtsN) )];
beq = [1];
% repmat(mean(Dst(:,1)),length(Dst),1)-Dst(:,1);
lb = zeros(length(MtsN),1);
ub = []; %ones((length(Mts)-MN),1);
x0=[];
% x0 = ones(1,(length(Mts)-MN));
% randi([0 1],1,length(Dst) );
options = optimoptions("intlinprog",MaxTime=120);
x = intlinprog(f,intcon,A,bp,Aeq,beq,lb,ub,x0,options);

T=[T ["Bx";string(TdateBx(x>0),'dd.MM.yyyy');
string(TdateBx(find(x>0)+999),'dd.MM.yyyy');
string(round(MtsStat(:,x>0),2)) ] ];

% By
MtsM=-0.03; %Mean
MtsMin=-43.1;
MtsMax=67.6;
MtsStd=3.99; %std
MtsS=0.1; %skewness
MtsK=5.9; %kurtosis

MN=1000; % Interval Length
k=find(omni2_all_years(:,16)~=999.9);
Mts=omni2_all_years(find(omni2_all_years(:,16)~=999.9),16); %By GSM
TdateBy=Tdate(find(omni2_all_years(:,16)~=999.9));

% floor(length(Mts)/MN)*
MtsN=[];
MtsStat=[];
for i=1:(length(Mts)-MN)
     if k(i)+999==k(MN+i-1)
    MtsN(1:MN,i)=Mts(i:MN+i-1,1);
    MtsStat(1,i)=mean(MtsN(:,i));
    MtsStat(2,i)=min(MtsN(:,i));
    MtsStat(3,i)=max(MtsN(:,i));
    MtsStat(4,i)=std(MtsN(:,i),1);
    MtsStat(5,i)=skewness(MtsN(:,i));
    MtsStat(6,i)=kurtosis(MtsN(:,i));
     end
end


Mk=abs(MtsM-MtsStat(1,:))/sum(abs(MtsM-MtsStat(1,:)))+...
  abs(MtsStd-MtsStat(4,:))/sum(abs(MtsStd-MtsStat(4,:)))+...
abs(MtsMin-MtsStat(2,:))/sum(abs(MtsMin-MtsStat(2,:)))+...
abs(MtsMax-MtsStat(3,:))/sum(abs(MtsMax-MtsStat(3,:)))+...
abs(MtsS-MtsStat(5,:))/sum(abs(MtsS-MtsStat(5,:)))+...
abs(MtsK-MtsStat(6,:))/sum(abs(MtsK-MtsStat(6,:)));

f = [Mk];
intcon = 1:length(MtsN);
A = []; %[eye(length(Mts)-MN)];
bp = []; %[1];
% bp = [5; 2; 5; 2; -1];
Aeq = [ones(1,length(MtsN) )];
beq = [1];
% repmat(mean(Dst(:,1)),length(Dst),1)-Dst(:,1);
lb = zeros(length(MtsN),1);
ub = []; %ones((length(Mts)-MN),1);
x0=[];
% x0 = ones(1,(length(Mts)-MN));
% randi([0 1],1,length(Dst) );
options = optimoptions("intlinprog",MaxTime=120);
x = intlinprog(f,intcon,A,bp,Aeq,beq,lb,ub,x0,options);

T=[T ["By";string(TdateBy(x>0),'dd.MM.yyyy');
string(TdateBy(find(x>0)+999),'dd.MM.yyyy');
string(round(MtsStat(:,x>0),2)) ] ];

% Bz
MtsM=-0.02; %Mean
MtsMin=-57.8;
MtsMax=41.6;
MtsStd=3.1; %std
MtsS=-0.1; %skewness
MtsK=11.5; %kurtosis

MN=1000; % Interval Length
k=find(omni2_all_years(:,17)~=999.9);
Mts=omni2_all_years(find(omni2_all_years(:,17)~=999.9),17); %Bz GSM
TdateBz=Tdate(find(omni2_all_years(:,17)~=999.9));

% floor(length(Mts)/MN)*
MtsN=[];
MtsStat=[];
for i=1:(length(Mts)-MN)
     if k(i)+999==k(MN+i-1)
    MtsN(1:MN,i)=Mts(i:MN+i-1,1);
    MtsStat(1,i)=mean(MtsN(:,i));
    MtsStat(2,i)=min(MtsN(:,i));
    MtsStat(3,i)=max(MtsN(:,i));
    MtsStat(4,i)=std(MtsN(:,i),1);
    MtsStat(5,i)=skewness(MtsN(:,i));
    MtsStat(6,i)=kurtosis(MtsN(:,i));
     end
end


Mk=abs(MtsM-MtsStat(1,:))/sum(abs(MtsM-MtsStat(1,:)))+...
  abs(MtsStd-MtsStat(4,:))/sum(abs(MtsStd-MtsStat(4,:)))+...
abs(MtsMin-MtsStat(2,:))/sum(abs(MtsMin-MtsStat(2,:)))+...
abs(MtsMax-MtsStat(3,:))/sum(abs(MtsMax-MtsStat(3,:)))+...
abs(MtsS-MtsStat(5,:))/sum(abs(MtsS-MtsStat(5,:)))+...
abs(MtsK-MtsStat(6,:))/sum(abs(MtsK-MtsStat(6,:)));

f = [Mk];
intcon = 1:length(MtsN);
A = []; %[eye(length(Mts)-MN)];
bp = []; %[1];
% bp = [5; 2; 5; 2; -1];
Aeq = [ones(1,length(MtsN) )];
beq = [1];
% repmat(mean(Dst(:,1)),length(Dst),1)-Dst(:,1);
lb = zeros(length(MtsN),1);
ub = []; %ones((length(Mts)-MN),1);
x0=[];
% x0 = ones(1,(length(Mts)-MN));
% randi([0 1],1,length(Dst) );
options = optimoptions("intlinprog",MaxTime=120);
x = intlinprog(f,intcon,A,bp,Aeq,beq,lb,ub,x0,options);

T=[T ["Bz";string(TdateBz(x>0),'dd.MM.yyyy');
string(TdateBz(find(x>0)+999),'dd.MM.yyyy');
string(round(MtsStat(:,x>0),2)) ] ];


% n
MtsM=6.7; %Mean
MtsMin=0;
MtsMax=137.2;
MtsStd=5.4; %std
MtsS=3.2; %skewness
MtsK=23.4; %kurtosis

MN=1000; % Interval Length
k=find(omni2_all_years(:,24)~=999.9);
Mts=omni2_all_years(find(omni2_all_years(:,24)~=999.9),24); %N
TdateN=Tdate(find(omni2_all_years(:,24)~=999.9));

% floor(length(Mts)/MN)*
MtsN=[];
MtsStat=[];
for i=1:(length(Mts)-MN)
     if k(i)+999==k(MN+i-1)
    MtsN(1:MN,i)=Mts(i:MN+i-1,1);
    MtsStat(1,i)=mean(MtsN(:,i));
    MtsStat(2,i)=min(MtsN(:,i));
    MtsStat(3,i)=max(MtsN(:,i));
    MtsStat(4,i)=std(MtsN(:,i),1);
    MtsStat(5,i)=skewness(MtsN(:,i));
    MtsStat(6,i)=kurtosis(MtsN(:,i));
     end
end


Mk=abs(MtsM-MtsStat(1,:))/sum(abs(MtsM-MtsStat(1,:)))+...
  abs(MtsStd-MtsStat(4,:))/sum(abs(MtsStd-MtsStat(4,:)))+...
abs(MtsMin-MtsStat(2,:))/sum(abs(MtsMin-MtsStat(2,:)))+...
abs(MtsMax-MtsStat(3,:))/sum(abs(MtsMax-MtsStat(3,:)))+...
abs(MtsS-MtsStat(5,:))/sum(abs(MtsS-MtsStat(5,:)))+...
abs(MtsK-MtsStat(6,:))/sum(abs(MtsK-MtsStat(6,:)));

f = [Mk];
intcon = 1:length(MtsN);
A = []; %[eye(length(Mts)-MN)];
bp = []; %[1];
% bp = [5; 2; 5; 2; -1];
Aeq = [ones(1,length(MtsN) )];
beq = [1];
% repmat(mean(Dst(:,1)),length(Dst),1)-Dst(:,1);
lb = zeros(length(MtsN),1);
ub = []; %ones((length(Mts)-MN),1);
x0=[];
% x0 = ones(1,(length(Mts)-MN));
% randi([0 1],1,length(Dst) );
options = optimoptions("intlinprog",MaxTime=120);
x = intlinprog(f,intcon,A,bp,Aeq,beq,lb,ub,x0,options);

T=[T ["n";string(TdateN(x>0),'dd.MM.yyyy');
string(TdateN(find(x>0)+999),'dd.MM.yyyy');
string(round(MtsStat(:,x>0),2)) ] ];


% Min Size Sample
 MSize=minsizesample();
 disp(MSize)
 disp(T)
 