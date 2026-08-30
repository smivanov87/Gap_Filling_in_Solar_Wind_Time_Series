function [TS] = fillgapsREG(TS,gaps_mask,omni2_all_years,Param)
%fillgapsREG-  Fill gaps using reconstruction from geomagnetic indices (REG).
%
%   Name:        fillgapsREG
%   Version:     1.0
%   Author:      Serhii M. Ivanov
%   Date:        2026
% 
%   Description:
%   fillgapsREG reconstructs missing data in the time series TS using the REG method.
% The function identifies the gaps using gaps_mask and uses the OMNI2 data in omni2_all_years 
% to reconstruct the missing values. The Param input specifies the solar wind parameter to be 
% reconstructed. The output TS contains the original time series with the missing values 
% filled using the REG method.

% Inputs:
% TS — input time series containing the original data and missing values to be reconstructed.
% gaps_mask — logical mask identifying the locations of the gaps in TS.
% omni2_all_years — OMNI2 dataset containing the solar wind and geomagnetic parameters used for the reconstruction.
% Param — identifier specifying the solar wind parameter to be reconstructed.

% Output:
% TS — time series with the missing values filled using the reconstruction from geomagnetic indices (REG) method.

% Param:
    % Param='V';
    % Param='n';
    % Param='Bz';
    % Param='Bx';
    % Param='By';

currentFolder = pwd;
% addpath(currentFolder);

    
if exist('Param','var')==0
    Param='V';
end


if strcmp(Param,'V')
    
    k = find(TS~=gaps_mask); 
    n=length(k);
    
    load(fullfile(strcat(currentFolder,'/GapReconstruction/Vsw/'), 'ParamV.mat'), 'Param');

        

for i=1:n-1
    if (k(i+1)-k(i)>1 && k(i+1)-k(i)-1<=50 && ...
            TS(k(i))~=gaps_mask && TS(k(i)-8)~=gaps_mask && TS(k(i)-2*8)~=gaps_mask && omni2_all_years(k(i+1)-1,39)~=99)
        
        p1=k(i);
        p2=k(i+1);
        g=p2-p1-1; %length of gap
        h=1;
                
         
            X=[round(omni2_all_years(p2-1, 39)/100,2) ...
            round(omni2_all_years(p2-1-4, 39)/100,2) ...
            round(omni2_all_years(p2-1-2*4, 39)/100,2) ...
            round(omni2_all_years(p2-1-3*4, 39)/100,2) ...
            round(omni2_all_years(p2-1-4*4, 39)/100,2) ...
            round(TS(p1)/1500,3) ...
            round(TS(p1-8)/1500,3) ...
            round(TS(p1-2*8)/1500,3) ...
            round(omni2_all_years(p2, 39)/100,2) ...
            round(TS(p2)/1500,3) ...
            ];
            [T,Eq,T1,ia]=Kpoly2(X,4);
            T=T(:,2:end);
                    % disp(strcat('size T= ',num2str(size(T)) ) );
                    for q=p1+1:p2-1
                        
                        load(strcat(currentFolder,'/GapReconstruction/Vsw/b_V',num2str(g),num2str(h),'.mat'), strcat('b_V',num2str(g),num2str(h)) ); %4 degree
                            if (abs([ones(length(T(:,1)),1) T]*eval(strcat('b_V',num2str(g),num2str(h)))*1500)<1200 && abs([ones(length(T(:,1)),1) T]*eval(strcat('b_V',num2str(g),num2str(h)))*1500)>200)
                        TS(p2-1-h+1,1)=abs([ones(length(T(:,1)),1) T]*eval(strcat('b_V',num2str(g),num2str(h)))*1500);
                            
                            end
                        h=h+1;
                    end
        end
 end
    
    k = find(TS~=gaps_mask); 
    n=length(k);
    for i=1:n-1
         if (k(i+1)-k(i)>1 && omni2_all_years(k(i+1)-1,39)~=99 )

        
        p1=k(i);
        p2=k(i+1);
        g=p2-p1-1; %length of gap
              X=[];  X=zeros(g,8000);
            for t=1:8000
                X(:,t)=[omni2_all_years(p1+2-t:p2-t, 39)];
            end   

            TS(p1+1:p2-1)=[ones(length(X(:,1)),1) X]*Param;
         end
    end

       
end


if strcmp(Param,'n')
    k = find(TS~=gaps_mask); 
    n=length(k);
        TS(find(TS(:, 1)==gaps_mask),1)=NaN;

        load(fullfile(strcat(currentFolder,'/GapReconstruction/n/'), 'b2_n.mat'), 'b2_n');
        % load("b2_n.mat","b2_n");
        for i=1:n-1
            if k(i+1)-k(i)-1>50
                p1=k(i);
                p2=k(i+1);
                % TS(p1+1:p2-1,1)=NaN; 
                for q=p1+1:p2-1
                    X=[round(omni2_all_years(q-17, 41)/1000,3) ...
                    round(omni2_all_years(q-15, 41)/1000,3) ...
                    round(omni2_all_years(q-13, 41)/1000,3) ... 
                    round(omni2_all_years(q-4, 41)/1000,3) ... 
                    round(omni2_all_years(q, 41)/1000,3) ...
                    round(omni2_all_years(q-1, 24)/200,3) ...
                    ];

                 
                [T,Eq,T1,ia]=Kpoly2(X,6); 
                T=T(:,2:end); %Kpoly2
                TS(q,1)=sig([ones(length(T(:,1)),1) T]*b2_n)*200;
                end

            end    
                if k(i+1)-k(i)>1 && k(i+1)>=20 && k(i+1)-k(i)-1<=50
                p1=k(i);
                p2=k(i+1);
                g=p2-p1-1; %length of gap
                h=1;
        
                 X=[round(omni2_all_years(p2-1, 41)/1000,3) ...
                    round(omni2_all_years(p2-1-6, 41)/1000,3) ...
                    round(omni2_all_years(p2-1-2*6, 41)/1000,3) ...
                    round(omni2_all_years(p2-1-3*6, 41)/1000,3) ...
                    round(TS(p1)/200,3) ...
                    round(TS(p1-5)/200,3) ...
                    round(TS(p1-2*5)/200,3) ...
                    round(TS(p1-3*5)/200,3) ...
                    round(omni2_all_years(p2, 41)/1000,3) ...
                    round(TS(p2)/200,3) ...
                    ];
                    
                    [T,Eq,T1,ia]=Kpoly2(X,4);
                    T=T(:,2:end); %Kpoly2
        
                for q=p1+1:p2-1
                    
                    load(strcat(currentFolder,'/GapReconstruction/n/b_n',num2str(g),num2str(h),'.mat'), strcat('b_n',num2str(g),num2str(h)) ); %4 degree
        
                    TS(p2-1-h+1,1)=abs([ones(length(T(:,1)),1) T]*eval(strcat('b_n',num2str(g),num2str(h)))*200);
                   
                    h=h+1;
                end
                
                end
        end
end


if strcmp(Param,'Bz')
    k = find(TS~=gaps_mask); 
    n=length(k);
        TS(find(TS(:, 1)==gaps_mask),1)=NaN;
       
        load(fullfile(strcat(currentFolder,'/GapReconstruction/Bz/'), 'b_bz.mat'), 'b_bz');
        % load("b_bz.mat","b_bz");
        for i=1:n-1
            if k(i+1)-k(i)-1>50
                p1=k(i);
                p2=k(i+1);
                
                x1=round(omni2_all_years(p1+1:p2-1, 41)/1000,2); 
                x2=round(omni2_all_years(p1+1+1:p2-1+1, 41)/1000,3);
                x3=round(omni2_all_years(p1+1+2:p2-1+2, 41)/1000,2);
                x4=round(omni2_all_years(p1+1+3:p2-1+3, 41)/1000,2);
                
                [T,Eq,T1,ia]=Kpoly2([x1 x2 x3 x4],10);
                T=T(:,2:end); %Kpoly2
                TS(p1+1:p2-1,1)=[ones(length(T(:,1)),1) T]*b_bz*100;
               
            end    

            if k(i+1)-k(i)>1 && k(i+1)>=20 && k(i+1)-k(i)-1<=50
                p1=k(i);
                p2=k(i+1);
                g=p2-p1-1; %length of gap
                h=1;
                
                 % Model 3
                 X=[round(omni2_all_years(p2-1, 41)/100,2) ...
                    round(omni2_all_years(p2-1-6, 41)/100,1) ...
                    round(omni2_all_years(p2-1-2*6, 41)/100,1) ...
                    round(omni2_all_years(p2-1-3*6, 41)/100,1) ...
                    round(TS(p1)/100,2) ...
                    round(TS(p1-4)/100,2) ...
                    round(TS(p1-2*4)/100,2) ...
                    round(TS(p1-3*4)/100,2) ...
                    round(omni2_all_years(p2, 41)/100,2) ...
                    round(TS(p2)/100,2) ...
                    ];
                    
                    [T,Eq,T1,ia]=Kpoly2(X,4);
                    T=T(:,2:end); %Kpoly2
        
        
                    for q=p1+1:p2-1
                        
                        load(strcat(currentFolder,'/GapReconstruction/Bz/b_z',num2str(g),num2str(h),'.mat'), strcat('b_z',num2str(g),num2str(h)) ); %4 degree
            
                        TS(p2-1-h+1,1)=[ones(length(T(:,1)),1) T]*eval(strcat('b_z',num2str(g),num2str(h)))*100;
                        
                        h=h+1;
                    end
                
            end
        end

end

if strcmp(Param,'Bx')
    k = find(TS~=gaps_mask); 
    n=length(k);
        TS(find(TS(:, 1)==gaps_mask),1)=NaN;
       
        for i=1:n-1
            if k(i+1)-k(i)>1 && k(i+1)>=20 && k(i+1)-k(i)-1<=50
                p1=k(i);
                p2=k(i+1);
                g=p2-p1-1; %length of gap
                h=1;
                 X=[round(omni2_all_years(p2-1, 39)/100,2) ...
                    round(omni2_all_years(p2-1-4, 39)/100,2) ...
                    round(omni2_all_years(p2-1-2*4, 39)/100,2) ...
                    round(omni2_all_years(p2-1-3*4, 39)/100,2) ...
                    round(omni2_all_years(p2-1-4*4, 39)/100,2) ...
                    round(TS(p1)/100,2) ...
                    round(TS(p1-5)/100,2) ...
                    round(TS(p1-2*5)/100,2) ...
                    round(TS(p1-3*5)/100,2) ...
                    round(omni2_all_years(p2, 39)/100,2) ...
                    round(TS(p2)/100,2) ...
                    ];
                    
                    [T,Eq,T1,ia]=Kpoly2(X,3);
                    T=T(:,2:end); %Kpoly2
        
                    for q=p1+1:p2-1
                        
                        load(strcat(currentFolder,'/GapReconstruction/Bx/b_x',num2str(g),num2str(h),'.mat'), strcat('b_x',num2str(g),num2str(h)) ); %3 degree
            
                        TS(p2-1-h+1,1)=[ones(length(T(:,1)),1) T]*eval(strcat('b_x',num2str(g),num2str(h)))*100;
                        
                        h=h+1;
                    end
                
            end
        end

end

if strcmp(Param,'By')
    k = find(TS~=gaps_mask); 
    n=length(k);
        TS(find(TS(:, 1)==gaps_mask),1)=NaN;
       
        for i=1:n-1
            if k(i+1)-k(i)>1 && k(i+1)>=20 && k(i+1)-k(i)-1<=50
                p1=k(i);
                p2=k(i+1);
                g=p2-p1-1; %length of gap
                h=1;
                 X=[round(omni2_all_years(p2-1, 39)/100,2) ...
                    round(omni2_all_years(p2-1-4, 39)/100,2) ...
                    round(omni2_all_years(p2-1-2*4, 39)/100,2) ...
                    round(omni2_all_years(p2-1-3*4, 39)/100,2) ...
                    round(omni2_all_years(p2-1-4*4, 39)/100,2) ...
                    round(TS(p1)/100,2) ...
                    round(TS(p1-4)/100,2) ...
                    round(TS(p1-2*4)/100,2) ...
                    round(TS(p1-3*4)/100,2) ...
                    round(omni2_all_years(p2, 39)/100,2) ...
                    round(TS(p2)/100,2) ...
                    ];
                    
                    [T,Eq,T1,ia]=Kpoly2(X,3);
                    T=T(:,2:end); %Kpoly2
        
        
                    for q=p1+1:p2-1
                        
                        load(strcat(currentFolder,'/GapReconstruction/By/b_y',num2str(g),num2str(h),'.mat'), strcat('b_y',num2str(g),num2str(h)) ); %3 degree
            
                        TS(p2-1-h+1,1)=[ones(length(T(:,1)),1) T]*eval(strcat('b_y',num2str(g),num2str(h)))*100;
                        
                        h=h+1;
                    end
                
            end
        end

end


%




end