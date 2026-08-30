function [TS] = fillgapsREGa2(TS,gaps_mask,vst,lag1,TSg,gaps_mask2,q,lag2,dt,smwindow)

%fillgapsREGa2-  Fill gaps using adaptive reconstruction (REGa).
%
%   Name:        fillgapsREGa
%   Version:     1.0
%   Author:      Serhii M. Ivanov
%   Date:        2026
% 
%   Description:
%       fillgapsREGa2 reconstructs missing portions of the time series TS
%       using the adaptive reconstruction (REGa) method.

%   Inputs:
%       TS         - Time series containing gaps.
%       gaps_mask  - Value identifying missing data in TS
%                    (e.g., 999.9 for OMNI data).
%       vst        - Dimension of the reconstructed attractor for TS.
%       lag1       - Time delay used to reconstruct the attractor for TS.
%       TSg        - Geomagnetic index time series used for reconstruction.
%       gaps_mask2 - Value identifying missing data in the geomagnetic
%                    index time series TSg.
%       q          - Dimension of the reconstructed attractor for TSg.
%       lag2       - Time delay used to reconstruct the attractor for TSg.
%       dt         - Moving-window length used for the reconstruction.
%       smwindow   - Smoothing-window length in hours.
%                    smwindow = 1 corresponds to no smoothing.
%                    smwindow > 1 applies smoothing over the specified
%                    number of hours.
%
%   Output:
%       TS         - Time series with the identified gaps reconstructed.
%
%
%   Example:
%       TS = fillgapsREGa2(TS,999.9,vst,lag1,TSg,999.9,q,lag2,dt,smwindow);
%
%   See also:
%       FILLGAPS, FILLREG, FILLAEM

 
if ~any(TS == gaps_mask) 
    disp('No gaps were found.');
    return;
end

if length(TS)~=length(TSg)
    disp('The input time series must have the same length.');
    return;
end

if length(TS)<100000
    disp('The input time series is too short. At least 100,000 samples are required.');
    return;
end

if ~exist('gaps_mask','var') || ~isnumeric(gaps_mask)
    disp('The variable "gaps_mask" is not defined. gaps_mask must be numeric.');
    return;
end

if sum(TSg == gaps_mask2)> sum(TSg~= gaps_mask2)
    disp('The number of gaps exceeds the observed data.');
    return;
end
    TS(isnan(TS))=gaps_mask;
    k = find(TS~=gaps_mask & ~isnan(TS));
    n=length(k);
    minTS=min(TS);
    TSls=fillgaps(TS,gaps_mask,'lin');
    
        for i=1:n-1
            if k(i+1)-k(i)>1 && k(i+1)-k(i)<1000 && k(i+1)<(sum(TSg~=gaps_mask2)-dt-2 ) && length(k(1:i))>dt
                p1=k(i);
                p2=k(i+1);
                g=p2-p1-1; %length of gap            
                TSl=TSls;
                t1=p1-dt; t2=p2;

                            X=[];  X=zeros(t2-t1+1,q);
                        for j=1:q
                            X(:,j)=[TSg(t1-lag2*(j-1):t2-lag2*(j-1) )]; 
                        end
                            X=[X TSg(t1+1:t2+1)];   

                        if vst>0
                            % vst=4;
                            TSst=zeros(t2-t1+1,vst);
                            for v=1:vst
                               
                                TSst(:,v)=TSl(t1-g-1-lag1*(v-1):t2-g-1-lag1*(v-1));
                            end
                            TSst=[TSst TSl(t1:t2)];
                             
               
                        TSl=TSl(t1-1:t2-1);
                        
                        X=[X TSst];
                        
                        else
                            TSl=TSl(t1-1:t2-1);
                            
                        end
                       
                        NumVer=length(X(1,:));
                        deg_kg=1;
                        [Nkg]=kg_terms(NumVer, deg_kg);
                        Nkg=Nkg+1;
                        
                        % disp(Nkg);
                        
                        
                            while length(TSl)>Nkg
                                deg_kg=deg_kg+1;
                                [Nkg]=kg_terms(NumVer, deg_kg);
                                    Nkg=Nkg+1;
                                if  Nkg>100000 || length(X(:,1))<Nkg
                                    % deg_kg>=5 ||
                                    % deg_kg=deg_kg-1;
                                    break
                                end
                            end

                            if Nkg>100000 
                                deg_kg=deg_kg-1;
                            end
                            % disp(Nkg);                              
                            % deg_kg=4;
                        [X]=Kpoly2(X,deg_kg);

                        % disp(length(TSl));
                           
                        if dt<=length(X(1,:))
                        X=X(:,1:dt);
                        % X=X(:,1:floor(0.98*length(X(:,1))));
                        end
                         % Normalization
                        dnorm=vecnorm(X,2,1);
                        dnorm(dnorm==0)=1;
                        X=X./dnorm;
                    % [b,flag] = lsqr(X, TSl, 1e-3, 100);
                    % disp(strcat('gap',num2str(g),' =',' sizeX=',num2str(size(X)),'; degree=',num2str(deg_kg),'; TSl=',num2str(length(TSl)),' X=',num2str(length(X(:,1))),' r=',num2str(corr(X*b, TSl)),' rmse= ',num2str(rmse(X*b, TSl)) ) ); 
                    % TS(p1+1:p2-1)=X(dt+1:dt+g,:)*b;
                    % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
                   for j=1:g

                    TSp=TSls(t1-1-g+j:t2-1-g+j);

                    [b, flag] = lsqr(X, TSp, 1e-3, 100);
                    
                    TS(p2-1-g+j)=X(end,:)*b;
                   
                    disp(strcat('gap',num2str(g),'-',num2str(j),'h =',' sizeX=',num2str(size(X)),'; degree=',num2str(deg_kg),'; r=',num2str(corr(X*b, TSp)),'; rmse= ',num2str(rmse(X*b, TSp)) ) );
                    % '; rankX=',num2str(rank(X)),'; rankX|Y',num2str(rank([X TSp])),
                   end 
                   TSls=fillgaps(TS,gaps_mask,'lin');
                   TS(p1+1:p2-1)=movmean(TS(p1+1:p2-1),smwindow);
           % break
            end

        end
        
            if minTS>=0
                TS(TS< 0) = 0;
            end

end % function