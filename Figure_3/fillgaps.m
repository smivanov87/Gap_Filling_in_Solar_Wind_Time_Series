function [TS] = fillgaps(TS,gaps_mask,met)
% % % % % % % % % % % % % % % % % % % % % % 
% % % % % Description  % % % % % % % % % % % 
%       fillgaps reconstructs missing portions of a solar wind time
%       series using the gap-filling method specified by MET.
%
%   Name:        fillgaps
%   Version:     1.0
%   Author:      Serhii M Ivanov
%   Date:        2025

%   Syntax:
%       TS = fillgaps(TS,gaps_mask,met)
%
%   Inputs:
%       TS        - Input time series containing gaps.
%       gaps_mask - Value identifying missing data (999.9 for OMNI data).
%       met       - Gap-filling method:
%
%                   'lin'   - Simple linear interpolation between the
%                             points on either side of the gap.
%
%                   'spline'- Spline interpolation.
%
%                   'makima'- Modified Akima interpolation.
%
%                   'ANP'   - Average of the two points immediately
%                             outside the gap. 
%
%                   'ACD'   - Average of all available completed data,
%                             excluding the gaps.
%
%                   'AOD'   - Average over all time in the database
%                             (excluding gaps).
%
%                   'RMD'   - White-noise-based gap filling.
%
%                   'MA'    - Moving-average interpolation.
%
%                   'NARX1' - First-degree polynomial model.
%
%                   'POL'   - Polynomial function of time.
%
%                   'NARX2' - Third-degree polynomial model.

%   Output:
%       TS        - Time series with the identified gaps filled.
%
%   EXAMPLE:
% Np=fillgaps(omni2_all_years(t1:t2,24),999.9,'lin'); %proton density

k = find(TS~=gaps_mask & ~isnan(TS)); 

if isempty(k)
    disp('No gaps were found.');
    return;
end

n=length(k);

if exist('met','var')==0
    met='lin';
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% linear interpolation % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

if strcmp(met,'lin')
    for i=1:n-1
        if k(i+1)-k(i)>1
            p1=k(i);
            p2=k(i+1);
            TS(p1+1:p2-1,1)=interp1([p1 p2],TS([p1 p2],1),p1+1:1:p2-1);
            % mean(TS([p1 p2],1));
        end
        
    end

end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% spline % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

if strcmp(met,'spline')
    pn=20;
    for i=11:n-1-11
        if k(i+1)-k(i)>1
            p1=k(i);
            p2=k(i+1);
            % 
            p3=k(i-pn):k(i-1);
            % p4=k(i+pn):k(i+1+pn);
            p4=k(i+2);
            % TS(p1+1:p2-1,1)=interp1([p3 p1 p2 p4],TS([p3 p1 p2 p4],1),p1+1:1:p2-1,'spline');
            TS(p1+1:p2-1,1)=spline([p3 p1 p2 p4],TS([p3 p1 p2 p4],1),p1+1:1:p2-1);
            % vq = interp1(x,v,xq,'pchip');
            % mean(TS([p1 p2],1));
        end
        
    end

end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% makima % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

if strcmp(met,'makima')
    pn=10;
    for i=pn+1:n-1-pn-1
        if k(i+1)-k(i)>1
            p1=k(i);
            p2=k(i+1);
            % 
            p3=k(i-pn):k(i-1);
            % p4=k(i+pn):k(i+1+pn);
            p4=k(i+2);
            
            if min(TS([p3 p1 p2 p4]))<0
                TS(p1+1:p2-1,1)=interp1([p3 p1 p2 p4],TS([p3 p1 p2 p4],1),p1+1:1:p2-1,'makima');
            else
                TS(p1+1:p2-1,1)=abs(interp1([p3 p1 p2 p4],TS([p3 p1 p2 p4],1),p1+1:1:p2-1,'makima'));
            end
            % vq = interp1(x,v,xq,'pchip');
            % mean(TS([p1 p2],1));
        end
        
    end

end


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Average (Nearest neighbor points) % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
        if strcmp(met,'ANP')
for i=1:n-1
    if k(i+1)-k(i)>1
        p1=k(i);
        p2=k(i+1);
        TS(p1+1:p2-1,1)=mean(TS([p1 p2],1));
    end
    
end
        end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% 'ACD' - average of all completed data, not including gaps
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

        if strcmp(met,'AOD')
TS(find(TS(:, 1)==gaps_mask),1)=NaN;
TS(isnan(TS(:, 1)),1)=mean(TS(:,1),'omitnan');
        end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% 'RND' % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
        if strcmp(met,'RND') 
            for i=1:n-1
                if k(i+1)-k(i)>1
                    p1=k(i);
                    p2=k(i+1);
                    % s = rng;
                    % TS(p1+1:p2-1,1)=normrnd(427,99,[p2-p1-1,1]);
                    rng(0,'twister');
                    a=TS(p1); b=TS(p2); 
                    TS(p1+1:p2-1,1)=(a + (b-a)*rand(1,p2-p1-1))';
                end
    
            end
        end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% 'MA' % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

if strcmp(met,'MA')
    TS(find(TS(:, 1)==gaps_mask),1)=NaN;
for i=1:n-1
    if k(i+1)-k(i)>1
        p1=k(i);
        p2=k(i+1);
        % TS(p1+1:p2-1,1)=NaN; 
        for j=p1+1:p2-1
        TS(j,1)=mean(TS(j-10:j-1,1),'omitnan' );
        end   
    end    
end
% TS(min(k):max(k),1)=movmean(TS(min(k):max(k),1),100);
end


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% 'NARX' % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

if strcmp(met,'NARX1')
    TS(find(TS(:, 1)==gaps_mask),1)=NaN;
    % nl=length(TS);
    for i=5000:n-1
        if k(i+1)-k(i)>1
            p1=k(i);
            p2=k(i+1);
            Y=TS(k(i-4059:i+1));
            % [T,Eq,T1,ia]=Kpoly([TS(k(i-9:i)) k(i-9:i)],4);
            [T,Eq,T1,ia]=Kpoly2([TS(k(i-4060:i)) TS(k(i-4061:i-1)) TS(k(i-4062:i-2)) TS(k(i-4063:i-3)) TS(k(i-4064:i-4))],1);
            % [b,bint,r,rint,stats]= regress(Y(ia),[ones(length(T1(:,1)),1) T1],0.05);
            [b,bint,r,rint,stats]= regress(Y(ia),T1,0.05);
             % stats(1,1)
            for j=p1:p2-2
            TS(j+1,1)=b(1)+b(2)*TS(j)+ b(3)*TS(j-1)+b(4)*TS(j-2)+b(5)*TS(j-3)+b(6)*TS(j-4);
                      % b(7)*TS(j)^2+ b(8)*TS(j)*TS(j-1)+b(9)*TS(j)*TS(j-2)+b(10)*TS(j)*TS(j-3)+b(11)*TS(j)*TS(j-4)+...
                      % b(12)*TS(j-1)^2+ b(13)*TS(j-1)*TS(j-2)+b(14)*TS(j-1)*TS(j-3)+b(15)*TS(j-1)*TS(j-4)+...
                      % b(16)*TS(j-2)^2+ b(17)*TS(j-2)*TS(j-3)+b(18)*TS(j-2)*TS(j-4)+b(19)*TS(j-3)^2+b(20)*TS(j-3)*TS(j-4)+b(21)*TS(j-4)^2;
            end
           
            
        end
        
    end


end

if strcmp(met,'POL')
    TS(find(TS(:, 1)==gaps_mask),1)=NaN;
for i=1:n-1
    if k(i+1)-k(i)>1 
        p1=k(i);
        p2=k(i+1);
        g=p2-p1-1; %length of gap
        % TS(p1+1:p2-1,1)=NaN; 
        % p1=8010; p2=8023;
        [p,~,mu] = polyfit([[k(i),k(i+1):k(i+1+30)]-k(i)]./10,TS([k(i),k(i+1):k(i+1+30)]),4);
        TS(p1+1:p2-1,1) = polyval(p,[[p1+1:p2-1]-k(i)]./10,[],mu);
        % plot(polyval(p,[[p1+1:p2-1]-k(i)]./10,[],mu))
        % [p,~,mu] = polyfit(1:20,TS(8023:8042),length(TS(8023:8042))-2);
        % plot(TS(8023:8042)); hold on; plot(polyval(p,1:20,[],mu)); hold off;
    end    
end
% [p,~,mu] = polyfit(k(i-20:i),TS(k(i-20:i)),19);
% f = polyval(p,k(i-20:i),[],mu);
% plot([TS(k(i-9:i)) f])
end

if strcmp(met,'NARX2')
    TS(find(TS(:, 1)==gaps_mask),1)=NaN;
    % nl=length(TS);
    for i=5000:n-1
        if k(i+1)-k(i)>1
            p1=k(i);
            p2=k(i+1);
            h=p2-p1+1;
            Y=TS(k(i-4059:i+1))/100;
            % Y=TS(p1-4059:p1);
            % [T,Eq,T1,ia]=Kpoly([TS(k(i-9:i)) k(i-9:i)],4);
            % [T,Eq,T1,ia]=Kpoly([TS(p1-4060:p1-1) TS(p1-4061:p1-2) TS(p1-4062:p1-3) TS(p1-4063:p1-4) TS(p1-4064:p1-5)],3);
            [T,Eq,T1,ia]=Kpoly2([TS(k(i-4060:i)) TS(k(i-4060-4:i-4)) TS(k(i-4060-2*4:i-2*4)) TS(k(i-4060-3*4:i-3*4))]/100,3);
            % [b,bint,r,rint,stats]= regress(Y(ia),[ones(length(T1(:,1)),1) T1],0.05);
            [b,bint,r,rint,stats]= regress(Y(ia),T1,0.05);
             % stats(1,1)
             % plot([Y [ones(length(T),1) T]*b])
             % corr([Y [ones(length(T),1) T]*b])
             % TS(k(i-4:i))'
            for j=p1:p2-2
              % TS(j+1,1)= [1 Kpoly([TS(j-h) TS(j-1-h) TS(j-2-h) TS(j-3-h) TS(j-4-h)],2)]*b;
              % TS(j+1,1)= [1 Kpoly([TS(j) TS(j-4) TS(j-2*4) TS(j-3*4)]/100,3)]*b*100;
              TS(j+1,1)= Kpoly2([TS(j) TS(j-4) TS(j-2*4) TS(j-3*4)]/100,3)*b*100;
              % TS(j+1,1)= [1 Kpoly(TS(j-4-h:j-h)',1)]*b;
            % TS(j+1,1)=b(1)+b(2)*TS(j)+ b(3)*TS(j-1)+b(4)*TS(j-2)+b(5)*TS(j-3)+b(6)*TS(j-4);
                      % b(7)*TS(j)^2+ b(8)*TS(j)*TS(j-1)+b(9)*TS(j)*TS(j-2)+b(10)*TS(j)*TS(j-3)+b(11)*TS(j)*TS(j-4)+...
                      % b(12)*TS(j-1)^2+ b(13)*TS(j-1)*TS(j-2)+b(14)*TS(j-1)*TS(j-3)+b(15)*TS(j-1)*TS(j-4)+...
                      % b(16)*TS(j-2)^2+ b(17)*TS(j-2)*TS(j-3)+b(18)*TS(j-2)*TS(j-4)+b(19)*TS(j-3)^2+b(20)*TS(j-3)*TS(j-4)+b(21)*TS(j-4)^2;
            end
           
            
        end
        
    end


end



TS([1:min(k)-1 max(k)+1:end],1)=NaN;
end