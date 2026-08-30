function [Mk] = OrderingMethods(MtsStat,Param)
%   Name:        OrderingMethods
%   Version:     1.0
%   Author:      Serhii M. Ivanov
%   Date:        2026

if exist('Param','var')==0
    Param='V';
end


if strcmp(Param,'V')

% V
MtsRMSE=0; %RMSE
MtsCorr1=1.0; %Corr1
MtsM=431; %Mean
MtsMin=262.0001;
MtsMax=775.0001;
MtsStd=101.6; %std
MtsS=0.99; %skewness
MtsK=4.01; %kurtosis



end

if strcmp(Param,'Bx')
% Bx
MtsRMSE=0.0; %RMSE
MtsCorr1=1.0; %Corr1
MtsM=0.04; %Mean
MtsMin=-15.6001;
MtsMax=11.7001;
MtsStd=3.67; %std
MtsS=-0.11; %skewness
MtsK=2.97; %kurtosis
end

if strcmp(Param,'By')
% By
MtsRMSE=0.0; %RMSE
MtsCorr1=1.0; %Corr1
MtsM=-0.03; %Mean
MtsMin=-14.70001;
MtsMax=23.10001;
MtsStd=4.14; %std
MtsS=0.05; %skewness
MtsK=5.4; %kurtosis
end

if strcmp(Param,'Bz')
% Bz
MtsRMSE=0.0; %RMSE
MtsCorr1=1.0; %Corr1
MtsM=-0.05001; %Mean
MtsMin=-22.9001;
MtsMax=20.9001;
MtsStd=3.54001; %std
MtsS=-0.036001; %skewness
MtsK=9.48001; %kurtosis
end

if strcmp(Param,'n')
% n
MtsRMSE=0.0; %RMSE
MtsCorr1=1.0; %Corr1
MtsM=6.6; %Mean
MtsMin=0.2;
MtsMax=50.8000001;
MtsStd=5.96; %std
MtsS=3.2; %skewness
MtsK=16.55; %kurtosis
end

Mk= (MtsCorr1-abs(MtsStat(1,:)))/sum(MtsCorr1-abs(MtsStat(1,:)))+...
    (MtsCorr1-abs(MtsStat(2,:)))/sum(MtsCorr1-abs(MtsStat(2,:)))+...
    abs(MtsRMSE-MtsStat(3,:))/sum(abs(MtsRMSE-MtsStat(3,:)))+...
    abs(MtsM-MtsStat(4,:))/sum(abs(MtsM-MtsStat(4,:)))+...
  abs(MtsStd-MtsStat(7,:))/sum(abs(MtsStd-MtsStat(7,:)))+...
abs(MtsMin-MtsStat(5,:))/sum(abs(MtsMin-MtsStat(5,:)))+...
abs(MtsMax-MtsStat(6,:))/sum(abs(MtsMax-MtsStat(6,:)))+...
abs(MtsS-MtsStat(8,:))/sum(abs(MtsS-MtsStat(8,:)))+...
abs(MtsK-MtsStat(9,:))/sum(abs(MtsK-MtsStat(9,:)));

% SE=sum(MtsCorr1-abs(MtsStat(1,:)))+...
%     sum(MtsCorr1-abs(MtsStat(2,:)))+...
%     sum(abs(MtsRMSE-MtsStat(3,:)))+...
%     sum(abs(MtsM-MtsStat(4,:)))+...
%   sum(abs(MtsStd-MtsStat(7,:)))+...
% sum(abs(MtsMin-MtsStat(5,:)))+...
% sum(abs(MtsMax-MtsStat(6,:)))+...
% sum(abs(MtsS-MtsStat(8,:)))+...
% sum(abs(MtsK-MtsStat(9,:)));
% 
% Mk= ( (MtsCorr1-abs(MtsStat(1,:)))+...
%     (MtsCorr1-abs(MtsStat(2,:)))+...
%     abs(MtsRMSE-MtsStat(3,:))+...
%     abs(MtsM-MtsStat(4,:))+...
%   abs(MtsStd-MtsStat(7,:))+...
% abs(MtsMin-MtsStat(5,:))+...
% abs(MtsMax-MtsStat(6,:))+...
% abs(MtsS-MtsStat(8,:))+...
% abs(MtsK-MtsStat(9,:)) )/SE;

% abs(MtsRMSE-MtsStat(3,:))/sum(abs(MtsRMSE-MtsStat(3,:)))+...
% abs(MtsCorr1-MtsStat(1,:))/sum(abs(MtsCorr1-MtsStat(1,:)))+...
% abs(MtsCorr1-abs(MtsStat(1,:)))/sum(abs(MtsCorr1-abs(MtsStat(1,:))))+...
end