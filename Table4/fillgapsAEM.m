function [TS] = fillgapsAEM(TS,gaps_mask,metric,analogue)
% % % % % % % % % % % % % % % % % % % % % % 
%   Name:        fillgapsAEM
%   Version:     1.0
%   Author:      Serhii M. Ivanov
%   Date:        2026
% % % % % % % % % % % % % % % % % % % % % % 
% fillgapsAEM Reconstructs missing values using the Analogue Ensemble Method.
%
%   TS = FILLGAPSAEM(TS,gaps_mask,metric,analogue) fills gaps in the input
%   time series TS using historical analogue segments of the same time
%   series.
%
%   GAPS_MASK specifies the numerical value used to identify missing data.
%
%   METRIC specifies the similarity measure used to identify analogue
%   segments:
%       'Corr'  - correlation coefficient
%       'RMSE'  - root mean square error
%
%   ANALOGUE specifies how the analogue segment is selected:
%       'best'    - uses the single most similar analogue
%       'average' - uses the mean of the five most similar analogues
%
%   The function processes gaps of up to 647 hours. The input time series
%   must contain more than 176500 valid observations.
%
%   Example:
%       TS = fillgapsAEM(TS,9999,'RMSE','best');
%
% gaps_mask=9999; 
% metric='Corr';
% metric='RMSE';
% analogue='best';
% analogue='average';


if isnumeric(gaps_mask)==0
    disp('gaps_mask must be in numeric format')
    return;
end
% k = find(omni2_all_years(:, 25)==9999);
k = find(TS~=gaps_mask & ~isnan(TS));
n=length(k);
% trace=[];
if n<=176500
    disp('The length of the time series is less then 176500 hours')
    return;
end

if exist('metric','var')==0
    metric='RMSE';
end

if exist('analogue','var')==0
    analogue='best';
end

    for i=n-1:-1:45000 %113314  %64900+648  %45000
        if k(i+1)-k(i)>1 && k(i+1)-k(i)<=647
            trace=[]; ensemble=[];
            p1=k(i);
            p2=k(i+1);
               trace(:,1)=TS(k(i-647:i)); 
               for j=1:floor(i/647-2) %100 %solar rotation
               ensemble(:,j)=TS(k(i-(j+1)*647:i-j*647)); %the same relative solar phase (e.g., same Carrington phase)
               end
                   if strcmp(metric,'Corr') && strcmp(analogue,'best')
                   c=corrcoef([trace ensemble]);
                   [a b]=max(abs(c(2:end,1)));
                   TS(p1+1:p2-1,1)= ensemble(2:2+p2-p1-2,b);
                   
                   elseif strcmp(metric,'RMSE') && strcmp(analogue,'best')
                   c=rmse(ensemble,trace);
                   [a b]=min(c);
                   TS(p1+1:p2-1,1)= ensemble(2:2+p2-p1-2,b);
                   
                   elseif strcmp(metric,'Corr') && strcmp(analogue,'average')
                   c=corrcoef([trace ensemble]);
                   [a b]=maxk(abs(c(2:end,1)),5);
                   TS(p1+1:p2-1,1)= mean(ensemble(2:2+p2-p1-2,b)')';
                   
                   elseif strcmp(metric,'RMSE') && strcmp(analogue,'average')
                   c=rmse(ensemble,trace);
                   [a b]=mink(c,5);
                   TS(p1+1:p2-1,1)= mean(ensemble(2:2+p2-p1-2,b)')';
                   
                   else
                       disp('You should only use Corr or RMSE similarity metrics')
                   end
            
        end
        
    end

% 

% TS([1:176499-1 max(k)+1:end],1)=NaN;
TS([1:45000-1 max(k)+1:end],1)=NaN;

% % % % % % 
end