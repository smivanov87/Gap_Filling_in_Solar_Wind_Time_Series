% figure3
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
% 
k=find(omni2_all_years(:,25)~=9999);  %V
t1=k(313424); t2=t1+999; %V
V=omni2_all_years(t1:t2,25); %V
Np=fillgaps(omni2_all_years(t1:t2,24),999.9,'lin'); %n
Tp=fillgaps(omni2_all_years(t1:t2,23),9999999,'lin'); %T
Bmag=vecnorm([omni2_all_years(t1:t2,13)'; omni2_all_years(t1:t2,16)'; omni2_all_years(t1:t2,17)'])'; %|B|
Dst=omni2_all_years(t1:t2,41); %Dst
Beta=fillgaps(omni2_all_years(t1:t2,37),999.99,'lin'); %Plasma Beta

SWC_pSlow = (2*(V < 450)  + 0.5*(Np > 3)  + 0.5*(Beta < 1))/3;
SWC_pFast = (2*(V >= 450) + 0.5*(Np < 20) + 0.5*(Beta < 1))/3;
SWC_slow = SWC_pSlow >= SWC_pFast; % SWC_slow = (V < 450);
SWC_fast = SWC_pFast > SWC_pSlow; % SWC_fast = (V >= 450);
        

kB = 1.380649e-23;        % J/K
Pth = Np .* 1e6 .* kB .* Tp;  % Pa
Pth_nPa = Pth*1e9;        % nPa
% Texp = (0.031*V - 5.1).^2 * 1e3; %Yermolaev
SWC_idx = (V < 500); R=1; Texp = zeros(size(V));
Texp(SWC_idx)=((0.0106*V(SWC_idx)-0.278).^3)/R;
Texp(~SWC_idx)=(0.77*V(~SWC_idx)-265)/R;
% SWC_rarefaction = (Np <= 1) & (V < 500) & (Tp./Texp < 1) & (Pth_nPa < 0.01);
% CIR
SWC_CIR=(0.5*(Np>3)+ 0.5*(Bmag>5) +3.0*(Tp./Texp >1) + 0.5*(Pth_nPa > 0.007)+0.5*(Beta>1))/5;
SWC_CIR=(SWC_CIR>=0.9);
% shock_candidate
    SWC_dV = 100*(V(2:end)-V(1:end-1)./V(1:end-1)); 
    SWC_dNp = 100*(Np(2:end)-Np(1:end-1))./Np(1:end-1);
    SWC_dT = 100*(Tp(2:end)-Tp(1:end-1))./Tp(1:end-1);
    SWC_dB = 100*(Bmag(2:end)-Bmag(1:end-1))./Bmag(1:end-1);
    SWC_c1 = SWC_dV  >= 4;
    SWC_c2 = SWC_dNp >= 60;
    SWC_c3 = SWC_dT  >= 20;
    SWC_c4 = SWC_dB  >= 25;
    SWC_nCriteria = SWC_c1 + SWC_c2 + SWC_c3 + SWC_c4;
    SWC_sum3 = SWC_dV + SWC_dNp + SWC_dT + SWC_dB;

SWC_shock_candidate = (SWC_nCriteria >= 3 & ...
     ((SWC_nCriteria == 3 & SWC_sum3 >= 80) | ...
      (SWC_nCriteria == 4 & SWC_sum3 >= 140))) ...
    | (SWC_dB >= 170);



colSlow  = [0.70 0.82 0.95];   % light blue
colFast  = [0.98 0.88 0.55];   % light yellow
colCIR   = [0.95 0.65 0.35];   % light orange
colShock = [0.85 0.45 0.45];   % muted red
fig1=figure(1); fig1.Position=[50 50 800 1200];
subplot(7,1,1); plot(V,'-k','LineWidth',1); dt=100; %V 
ylabel('$V_{SW}$, \quad [km\,$s^{-1}$]', 'interpreter', 'latex','FontSize', 14); set(gca,'XTickLabel',[]); set(gca,'FontSize',14);%hold on;
SWC(SWC_slow,SWC_fast,SWC_shock_candidate,SWC_CIR,colSlow,colFast,colCIR,colShock); %hold off;
subplot(7,1,2); plot(Np,'-k','LineWidth',1) %n
ylabel('$n$, \quad [N cm$^{-3}$]', 'interpreter', 'latex','FontSize', 14);
SWC(SWC_slow,SWC_fast,SWC_shock_candidate,SWC_CIR,colSlow,colFast,colCIR,colShock); set(gca,'XTickLabel',[]);set(gca,'FontSize',14);
subplot(7,1,3); plot(Tp,'-k','LineWidth',1) %T [$K$]
ylabel('$T_p$, \quad [$K$]', 'interpreter', 'latex','FontSize', 14);
SWC(SWC_slow,SWC_fast,SWC_shock_candidate,SWC_CIR,colSlow,colFast,colCIR,colShock); set(gca,'XTickLabel',[]);set(gca,'FontSize',14);
subplot(7,1,4); plot(Bmag,'-k','LineWidth',1); % hold off;
ylabel('$|B|$, \quad [$nT$]', 'interpreter', 'latex','FontSize', 14);
SWC(SWC_slow,SWC_fast,SWC_shock_candidate,SWC_CIR,colSlow,colFast,colCIR,colShock); set(gca,'XTickLabel',[]);set(gca,'FontSize',14);
subplot(7,1,5); plot(Pth_nPa,'-k','LineWidth',1); % hold off;
ylabel('$P_{th}$, \quad [$nPa$]', 'interpreter', 'latex','FontSize', 14);
SWC(SWC_slow,SWC_fast,SWC_shock_candidate,SWC_CIR,colSlow,colFast,colCIR,colShock); set(gca,'XTickLabel',[]);set(gca,'FontSize',14);
subplot(7,1,6); plot(Beta,'-k','LineWidth',1); % hold off;
ylabel('$\beta$', 'interpreter', 'latex','FontSize', 14);
SWC(SWC_slow,SWC_fast,SWC_shock_candidate,SWC_CIR,colSlow,colFast,colCIR,colShock); set(gca,'XTickLabel',[]);set(gca,'FontSize',14);
subplot(7,1,7); plot(1:1000,Dst,'-k','LineWidth',1) %Dst
ylabel('$Dst$, \quad [$nT$]', 'interpreter', 'latex','FontSize', 14);
SWC(SWC_slow,SWC_fast,SWC_shock_candidate,SWC_CIR,colSlow,colFast,colCIR,colShock); 
set(gca,'FontSize',14); xticks(1:dt:1000); xticklabels([string(datetime(Tdate(t1:dt:t2),'Format',"dd-MMM, HH:mm"))]); xlabel('UT','FontSize', 14);
hSlow  = patch(NaN,NaN,colSlow,'EdgeColor','none','FaceAlpha',0.25);
hFast  = patch(NaN,NaN,colFast,'EdgeColor','none','FaceAlpha',0.25);
% hComp  = patch(NaN,NaN,[1.00 0.55 0.20],'EdgeColor','none','FaceAlpha',0.25);
% hRare  = patch(NaN,NaN,[0.55 0.65 1.00],'EdgeColor','none','FaceAlpha',0.25);
hCIR  = patch(NaN,NaN,colCIR,'EdgeColor','none','FaceAlpha',0.25);
hShock = patch(NaN,NaN,colShock,'EdgeColor','none');
% legend([hSlow hFast hComp hRare hShock],{'Slow','Fast','Compession','Rarefaction','Shock Candidate'},'NumColumns',5, 'Location','northoutside');
legend([hSlow hFast hCIR hShock],{'Slow','Fast','CIRs','Shock Candidate'},'NumColumns',5, 'Location','northoutside');
