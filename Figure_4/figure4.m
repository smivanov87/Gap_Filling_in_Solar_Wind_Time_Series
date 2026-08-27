% Figure 4
% Data
% OMNI
url = 'https://spdf.gsfc.nasa.gov/pub/data/omni/low_res_omni/omni2_all_years.dat';
filename = 'omni2_all_years.dat';
websave(filename, url);
load omni2_all_years.dat -ascii;
Tdate=datetime(omni2_all_years(1:end,1),month(omni2_all_years(1:end,2)),day(omni2_all_years(1:end,2)),omni2_all_years(1:end,3),0,0  );
% 
SSA_folder = fullfile(pwd, 'SSA');

if ~isfolder(SSA_folder)
url = 'https://github.com/Jorsorokin/SingularSpectrum/archive/refs/heads/master.zip';
zipFile = 'SingularSpectrum.zip';
websave(zipFile, url);
unzip(zipFile);
delete(zipFile);
movefile('SingularSpectrum-master', 'SSA');
end


if ~isfolder(fullfile(pwd, 'GapReconstruction'))
    mkdir('GapReconstruction');

    downloadFolder = fullfile(pwd, 'GapReconstruction');

    apiURL = ['https://api.github.com/repos/' ...
        'smivanov87/Gap_Filling_in_Solar_Wind_Time_Series/contents/' ...
        'Figure_4/GapReconstruction'];

    files = webread(apiURL);

    for i = 1:length(files)

        if strcmp(files(i).type, 'file')

            filename = files(i).name;
            downloadURL = files(i).download_url;
            filePath = fullfile(downloadFolder, filename);

            fprintf('Downloading %s...\n', filename);
            websave(filePath, downloadURL);

            % Unzip ZIP files
            if endsWith(filename, '.zip', 'IgnoreCase', true)
                fprintf('Extracting %s...\n', filename);
                unzip(filePath, downloadFolder);

                % Delete ZIP file
                delete(filePath);
            end
        end
    end
end




% Solar wind Classification (Categories)
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

%Rarefaction
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

% 
k=find(omni2_all_years(:,25)~=9999);  %V
t1=k(313424); t2=t1+999; %V
% 
ids=[];
ids=[313449 313453 313455 313460 313465 313467 313470 314386 314389 314394]; %1h
ids=[ids 313427:313428 313431:313432 313440:313441 313445:313446]; %2h
ids=[ids 313517:313519 313526:313528 313556:313558 313705:313707 313965:313967]; %3h
ids=[ids 313993:313996 313799:313802]; %4h
ids=[ids 313532:313536 313572:313576]; %5h
ids=[ids 314066:314071 313897:313902]; %6h
ids=[ids 313943:313949 ]; %7h
ids=[ids 313748:313755 ]; %8h
ids=[ids 314151:314159 ]; %9h
ids=[ids 313917:313926 ]; %10h
ids=[ids 313542:313552 ]; %11h
ids=[ids 313814:313825 ]; %12h
ids=[ids 313718:313730 ]; %13h
ids=[ids 313977:313990 ]; %14h
ids=[ids 314179:314193 ]; %15h
ids=[ids 314201:314216 ]; %16h
ids=[ids 314102:314118 ]; %17h
ids=[ids 314258:314275 ]; %18h
ids=[ids 313491:313509 ]; %19h
ids=[ids 313770:313789 ]; %20h
ids=[ids 314230:314250 ]; %21h
ids=[ids 314030:314051 ]; %22h
ids=[ids 313667:313689 ]; %23h
ids=[ids 313620:313643 ]; %24h
ids=[ids 313580:313609 313840:313879 314303:314352]; %25h for V 314320:314369  314284:314333 314300:314350

V=omni2_all_years(:,25); V(find(V==9999))=NaN; TdateV=Tdate; %V

ma=9999; %V
% ma=999.9; %Bx By Bz, Density
Vcalc=V; V(k(ids))=NaN; 
V1(1:length(V),1)=NaN;
% V1(find(isnan(V)))=Vcalc(find(isnan(V))); %simulated gaps
V1(sort(unique([k(ids); k(ids)-1; k(ids)+1])))=Vcalc(sort(unique([k(ids); k(ids)-1; k(ids)+1]))); %simulated gaps
V2=V; V2(k(ids))=ma;
met='lin';
V2=fillgaps(V2,ma,met);
V2(setdiff(1:end,k(ids)))=NaN;
met='ANP';
V3=V; V3(k(ids))=ma; V3=fillgaps(V3,ma,met);
V3(setdiff(1:end,k(ids)))=NaN;
met='AOD';
V4=V; V4(k(ids))=ma; V4=fillgaps(V4,ma,met);
V4(setdiff(1:end,k(ids)))=NaN;
met='RND';
V5=V; V5(k(ids))=ma; V5=fillgaps(V5,ma,met); 
V5(setdiff(1:end,k(ids)))=NaN;
met='spline';
V6=V; V6(k(ids))=ma; V6=fillgaps(V6,ma,met);
V6(setdiff(1:end,k(ids)))=NaN;
met='makima';
V7=V; V7(k(ids))=ma; V7=fillgaps(V7,ma,met);
V7(setdiff(1:end,k(ids)))=NaN;
'analogue ensemble method'; metric='Corr';  analogue='best'; 
V8=V; V8(k(ids))=ma; V8=fillgapsAEM(V8,ma,metric,analogue);
V8(setdiff(1:end,k(ids)))=NaN;
metric='Corr'; analogue='average';
V9=V; V9(k(ids))=ma; V9=fillgapsAEM(V9,ma,metric,analogue);
V9(setdiff(1:end,k(ids)))=NaN;
metric='RMSE';analogue='best'; 
V10=V; V10(k(ids))=ma; V10=fillgapsAEM(V10,ma,metric,analogue);
V10(setdiff(1:end,k(ids)))=NaN;
metric='RMSE';analogue='average';
V11=V; V11(k(ids))=ma; V11=fillgapsAEM(V11,ma,metric,analogue);
V11(setdiff(1:end,k(ids)))=NaN;
% for calculations
Vl=Vcalc; Vl(k(ids))=ma; met='lin'; Vl=fillgaps(Vl,ma,met); V2(sort(unique([k(ids); k(ids)-1; k(ids)+1])) )=Vl(sort(unique([k(ids); k(ids)-1; k(ids)+1])) ); %to connect real data with the reconstructed data
Vn=Vcalc; Vn(k(ids))=ma; met='ANP'; Vn=fillgaps(Vn,ma,met);
Va=Vcalc; Va(k(ids))=ma; met='AOD'; Va=fillgaps(Va,ma,met);
Vr=Vcalc; Vr(k(ids))=ma; met='RND'; Vr=fillgaps(Vr,ma,met);
Vs=Vcalc; Vs(k(ids))=ma; met='spline'; Vs=fillgaps(Vs,ma,met);
Vm=Vcalc; Vm(k(ids))=ma; met='makima'; Vm=fillgaps(Vm,ma,met); V7(sort(unique([k(ids); k(ids)-1; k(ids)+1])) )=Vm(sort(unique([k(ids); k(ids)-1; k(ids)+1])) );  %to connect real data with the reconstructed data
Vecb=Vcalc; Vecb(k(ids))=ma; 'ensembleCorrBest'; metric='Corr';  analogue='best'; Vecb=fillgapsAEM(Vecb,ma,metric,analogue);
Veca=Vcalc; Veca(k(ids))=ma; 'ensembleCorrBest'; metric='Corr';  analogue='average'; Veca=fillgapsAEM(Veca,ma,metric,analogue);
Verb=Vcalc; Verb(k(ids))=ma; 'ensembleCorrBest'; metric='RMSE';  analogue='best'; Verb=fillgapsAEM(Verb,ma,metric,analogue);
Vera=Vcalc; Vera(k(ids))=ma; 'ensembleCorrBest'; metric='RMSE';  analogue='average'; Vera=fillgapsAEM(Vera,ma,metric,analogue);
met='NARX1'; %For V, N
V12=V; V12(k(ids))=ma; V12=fillgaps(V12,ma,met);
V12(setdiff(1:end,k(ids)))=NaN;
Vnarx=Vcalc; Vnarx(k(ids))=ma; Vnarx=fillgaps(Vnarx,ma,met);
met='MA';
V13=V; V13(k(ids))=ma; V13=fillgaps(V13,ma,met);
V13(setdiff(1:end,k(ids)))=NaN;
Vma=Vcalc; Vma(k(ids))=ma; Vma=fillgaps(Vma,ma,met); V13(sort(unique([k(ids); k(ids)-1; k(ids)+1])) )=Vma(sort(unique([k(ids); k(ids)-1; k(ids)+1])) ); %to connect real data with the reconstructed data
met='REG'; 
Param='V';
% Param='n';
% Param='Bz';
% Param='Bx';
% Param='By';
V14=V; V14(k(ids))=ma; [V14]=fillgapsREG(V14,ma,omni2_all_years,Param);
V14(setdiff(1:end,k(ids)))=NaN;
Vreg=Vcalc; Vreg(k(ids))=ma; [Vreg]=fillgapsREG(Vreg,ma,omni2_all_years,Param); 
V14(sort(unique([k(ids); k(ids)-1; k(ids)+1])) )=Vreg(sort(unique([k(ids); k(ids)-1; k(ids)+1])) ); %to connect real data with the reconstructed data
V15=V; V15(k(ids))=ma; V15=fillgapsSSA(V15(t1:t2),ma); V15(t1:t2)=V15; V15([1:t1-1, t2+1:length(V)])=V([1:t1-1, t2+1:length(V)]);
V15(setdiff(1:end,k(ids)))=NaN;
Vssa=Vcalc; Vssa(k(ids))=ma; Vssa=fillgapsSSA(Vssa(t1:t2),ma); Vssa(t1:t2)=Vssa; Vssa([1:t1-1, t2+1:length(Vcalc)])=Vcalc([1:t1-1, t2+1:length(Vcalc)]);
V15(sort(unique([k(ids); k(ids)-1; k(ids)+1])) )=Vssa(sort(unique([k(ids); k(ids)-1; k(ids)+1])) ); 
% % % 'V'; TSg=omni2_all_years(:,39); gaps_mask2=99;
% % % 'V'; V17=V; V17(k(ids))=ma; V17(setdiff(1:end,t1-42000:t2+42000))=ma; [V17]=fillgapsREGa(V17,ma,3,8,TSg,gaps_mask2,5,4,500,7); %V single adaptation
'V'; TSg=omni2_all_years(:,39); gaps_mask2=99;
'V'; V17=V; V17(k(ids))=ma; V17(setdiff(1:end,t1-10000:t2+10000))=ma; [V17]=fillgapsREGa2(V17,ma,3,8,TSg,gaps_mask2,5,4,3000,3); %V
% 'n'; TSg=omni2_all_years(:,41); gaps_mask2=99999;
% 'n'; V17=V; V17(k(ids))=ma; V17(setdiff(1:end,t1-7000:t2+100))=ma; [V17]=fillgapsREGa2(V17,ma,4,5,TSg,gaps_mask2,4,6,3000,1); %2100 2600 2700 2900
% 'Bx'; TSg=omni2_all_years(:,39); gaps_mask2=99;
% 'Bx'; V17=V; V17(k(ids))=ma; V17(setdiff(1:end,t1-10000:t2+10000))=ma; [V17]=fillgapsREGa2(V17,ma,4,5,TSg,gaps_mask2,5,4,3000,3);
% 'By'; TSg=omni2_all_years(:,39); gaps_mask2=99;
% 'By'; V17=V; V17(k(ids))=ma; V17(setdiff(1:end,t1-10000:t2+10000))=ma; [V17]=fillgapsREGa2(V17,ma,4,4,TSg,gaps_mask2,5,4,5000,1); %7 %4500
% 'Bz'; TSg=omni2_all_years(:,41); gaps_mask2=99999;
% 'Bz'; V17=V; V17(k(ids))=ma; V17(setdiff(1:end,t1-10000:t2+10000))=ma; [V17]=fillgapsREGa2(V17,ma,4,4,TSg,gaps_mask2,4,6,3000,5);
% plot(Vcalc(t1:t2)); hold on; plot(V17(t1:t2)); hold off; 
% [corr(Vcalc(t1:t2),V17(t1:t2))  corr(Vcalc(k(ids)),V17(k(ids))) rmse(Vcalc(t1:t2),V17(t1:t2)) kurtosis(V17(t1:t2))]
% semilogy(svd(X)); grid on;
V17(setdiff(1:end,k(ids)))=NaN; %plot(V17); plot(Vrega)
Vrega=Vcalc; Vrega(k(ids))=V17(k(ids)); %Vrega(k(ids))=ma; [Vrega]=fillgapsREGa(Vrega,ma,TSg,gaps_mask2); 
V17(sort(unique([k(ids); k(ids)-1; k(ids)+1])) )=Vrega(sort(unique([k(ids); k(ids)-1; k(ids)+1])) ); 
% met='POL';
% V16=V; V16(ids)=ma; V16=fillgaps(V16,ma,met);
% V16(setdiff(1:end,ids))=NaN;
% Vpol=Vcalc; Vpol(ids)=ma; Vpol=fillgaps(Vpol,ma,met);
% met='NARX2'; %for Bz, Bx, By
% V12=V; V12(k(ids))=ma; V12=fillgaps(V12,ma,met);
% V12(setdiff(1:end,k(ids)))=NaN;
% Vnarx=Vcalc; Vnarx(k(ids))=ma; Vnarx=fillgaps(Vnarx,ma,met);
% t1=441106; t2=441156; plot(Vcalc(t1:t2)); hold on; plot(V14(t1:t2)); hold off; 


c1 = [0.00 0.00 0.00];   % Observed     - black
c2 = [0.00 0.45 0.74];   % REG          - blue
c3 = [0.85 0.33 0.10];   % REGa         - vermilion
c4 = [0.47 0.31 0.63];   % SSA          - purple
c5 = [0.00 0.55 0.50];   % MKM          - teal
c6 = [0.55 0.55 0.55];   % Simulated    - grey
colSlow  = [0.70 0.82 0.95];   % light blue
colFast  = [0.98 0.88 0.55];   % light yellow
colCIR   = [0.95 0.65 0.35];   % light orange
colShock = [0.85 0.45 0.45];   % muted red

% t1=441063; t2=441143; t1=k(313424); t2=t1+999; %V
fig1=figure(1); fig1.Position=[50 50 800 1200];
ax1=subplot(3,1,1); %Position = [0.1300    0.6600    0.7750    0.3300];
hold(ax1,'on'); dt=100; t1=k(313424);t2=t1+999; %t1=k(313424);t2=t1+333; %V
% dt=100; t1=k(170266); t2=t1+333; %n
% dt=100; t1=k(198196); t2=t1+333; %Bz
p1=plot(t1:t2,V(t1:t2),'color',c1,'LineWidth',1.5); %hold on; % was V (Vcalc) % Observed (black)
p2=plot(t1:t2,V14(t1:t2),'Color',c2,'LineWidth',1.5); % (REG)
% p3=plot(t1:t2,V13(t1:t2),'Color', c3,'LineWidth',1.5);  % (MA)
p3=plot(t1:t2,V17(t1:t2),'Color', c3,'LineWidth',1.5);  % (REGa)
% p4=plot(t1:t2,V2(t1:t2) ,'Color', c4,'LineWidth',1.5); %  (LIN)
p4=plot(t1:t2,V15(t1:t2) ,'Color', c4,'LineWidth',1.5); %  (SSA)
p5=plot(t1:t2,V7(t1:t2),'Color',c5,'LineWidth',1.5); %hold off;  ...      %  (MKM)
p6=patch(t1:t2,V1(t1:t2),'b',...
      'FaceColor','none',...
      'EdgeColor',c6,...
      'EdgeAlpha',1,...
      'LineWidth',1.5); %Simulated Gaps Medium gray
ylabel(strcat('$V_{SW} \quad$', '[$km$ $s^{-1}$]'),'interpreter', "latex",'FontSize', 14); ylim([250 700]); %V
% ylabel(strcat('$Proton \quad Density \quad$', '[$N$ $cm^{-3}$]'),'interpreter', "latex",'FontSize', 14);  %for N
set(gca,'FontSize',14); xticks(t1:dt:t2); xticklabels([string(datetime(TdateV(t1:dt:t2),'Format',"dd-MMM, HH:mm"))]); xlabel('UT','FontSize', 14);
xlim([t1 t1+333]); %xlim([t1 t2]); 
legend(ax1,[p1 p2 p3 p4 p5 p6],{'Observed',...
    'Reconstruction from the Kp Index - REG',...
    'Adaptive Reconstruction - REGa',...
    'Singular Spectrum Analysis - SSA',...
    'Makima - MKM',...
    'Simulated Gaps'},...
    'interpreter', "latex",'FontSize',14,'BackgroundAlpha',0,'Location','northwest'); %V
legend boxoff; title('(a)','position',[t1-20, max(ylim), 0]);
% hold(ax1,'off');
ax2 = axes('Position',ax1.Position,'Color','none','XTick',[],'YTick',[],'Box','off');
xregion(find(diff([false; SWC_slow])==1)+t1-1,find(diff([SWC_slow;false])==-1)+t1-1,'FaceColor',colSlow,'EdgeColor','none'); %Light blue
xregion(find(diff([false; SWC_fast])==1)+t1,find(diff([SWC_fast;false])==-1)+t1,'FaceColor',colFast,'EdgeColor','none'); %Light yellow
% xregion(find(diff([false; SWC_compression])==1)+t1,find(diff([SWC_compression;false])==-1)+t1,'FaceColor',[1.00 0.55 0.20],'EdgeColor','none'); % Orange-red
% xregion(find(diff([false; SWC_rarefaction])==1)+t1,find(diff([SWC_rarefaction;false])==-1)+t1,'FaceColor',[0.55 0.65 1.00],'EdgeColor','none'); %Purple
xregion(find(diff([false; SWC_CIR])==1)+t1,find(diff([SWC_CIR;false])==-1)+t1,'FaceColor',colCIR,'EdgeColor','none'); % Orange-red
xregion(find(diff([false; SWC_shock_candidate])==1)+t1,find(diff([SWC_shock_candidate;false])==-1)+t1,'FaceColor',colShock,'EdgeColor',colShock,'LineWidth',1,'FaceAlpha',0.25); %muted red
hSlow  = patch(NaN,NaN,colSlow,'EdgeColor','none','FaceAlpha',0.25);
hFast  = patch(NaN,NaN,colFast,'EdgeColor','none','FaceAlpha',0.25);
% hComp  = patch(NaN,NaN,[1.00 0.55 0.20],'EdgeColor','none','FaceAlpha',0.25);
% hRare  = patch(NaN,NaN,[0.55 0.65 1.00],'EdgeColor','none','FaceAlpha',0.25);
hCIR  = patch(NaN,NaN,colCIR,'EdgeColor','none','FaceAlpha',0.25);
hShock = patch(NaN,NaN,colShock,'EdgeColor','none');
% legend(ax2,[hSlow hFast hComp hRare hShock],{'Slow','Fast','Compression', 'Rarefaction', 'Shock Candidate'},'NumColumns',5,'FontSize',14, 'Location','northoutside');
legend(ax2,[hSlow hFast hCIR hShock],{'Slow','Fast','CIRs', 'Shock Candidate'},'NumColumns',5,'FontSize',14, 'Location','northoutside');
xlim([t1 t1+333]); %xlim([t1 t2]); 

ax3 =subplot(3,1,2); %hp(2).Position = [0.1300    0.1300    0.7750    0.4100];
% fig1=figure(1); fig1.Position=[50 50 800 1200];
hold(ax3,'on'); dt=100; %t1=k(313424)+334;t2=t1+333; %V
% dt=100; t1=k(170266)+334; t2=t1+333; %n
% dt=100; t1=k(198196)+334; t2=t1+333; %n
p1=plot(t1:t2,V(t1:t2),'color',c1,'LineWidth',1.5); %hold on; % was V (Vcalc) % Observed (black)
p2=plot(t1:t2,V14(t1:t2),'Color',c2,'LineWidth',1.5); % (REG)
% p3=plot(t1:t2,V13(t1:t2),'Color', c3,'LineWidth',1.5);  % (MA)
p3=plot(t1:t2,V17(t1:t2),'Color', c3,'LineWidth',1.5);  % (REGa)
% p4=plot(t1:t2,V2(t1:t2) ,'Color', c4,'LineWidth',1.5); %  (LIN)
p4=plot(t1:t2,V15(t1:t2) ,'Color', c4,'LineWidth',1.5); %  (SSA)
p5=plot(t1:t2,V7(t1:t2),'Color',c5,'LineWidth',1.5); %hold off;  ...      %  (MKM)
p6=patch(t1:t2,V1(t1:t2),'b',...
      'FaceColor','none',...
      'EdgeColor',c6,...
      'EdgeAlpha',1,...
      'LineWidth',1.5);
ylabel(strcat('$V_{SW} \quad$', '[$km$ $s^{-1}$]'),'interpreter', "latex",'FontSize', 14); %V
% ylabel(strcat('$Proton \quad Density \quad$', '[$N$ $cm^{-3}$]'),'interpreter', "latex",'FontSize', 14);  %for N
set(gca,'FontSize',14); xticks(t1:dt:t2); xticklabels([string(datetime(TdateV(t1:dt:t2),'Format',"dd-MMM, HH:mm"))]); xlabel('UT','FontSize', 14);
xlim([t1+334 t1+666]); ylim([300 550]); title('(b)','position',[t1+334-20, max(ylim), 0]); %V
% hold(ax1,'off');
ax4 = axes('Position',ax3.Position,'Color','none','XTick',[],'YTick',[],'Box','off');
xregion(find(diff([false; SWC_slow])==1)+t1-1,find(diff([SWC_slow;false])==-1)+t1-1,'FaceColor',colSlow,'EdgeColor','none'); %Light blue
xregion(find(diff([false; SWC_fast])==1)+t1,find(diff([SWC_fast;false])==-1)+t1,'FaceColor',colFast,'EdgeColor','none'); %Light yellow
% xregion(find(diff([false; SWC_compression])==1)+t1,find(diff([SWC_compression;false])==-1)+t1,'FaceColor',[1.00 0.55 0.20],'EdgeColor','none'); % Orange-red
% xregion(find(diff([false; SWC_rarefaction])==1)+t1,find(diff([SWC_rarefaction;false])==-1)+t1,'FaceColor',[0.55 0.65 1.00],'EdgeColor','none'); %Purple
xregion(find(diff([false; SWC_CIR])==1)+t1,find(diff([SWC_CIR;false])==-1)+t1,'FaceColor',colCIR,'EdgeColor','none'); % Orange-red
xregion(find(diff([false; SWC_shock_candidate])==1)+t1,find(diff([SWC_shock_candidate;false])==-1)+t1,'FaceColor',colShock,'EdgeColor',colShock,'LineWidth',1,'FaceAlpha',0.25); %muted red
xlim([t1+334 t1+666]);

ax5 =subplot(3,1,3); %hp(2).Position = [0.1300    0.1300    0.7750    0.4100];
% fig1=figure(1); fig1.Position=[50 50 800 1200];
hold(ax5,'on');dt=100; %t1=k(313424)+667;t2=t1+333; %V
% dt=100; t1=k(170266)+667; t2=t1+333; %n
% dt=100; t1=k(198196)+667; t2=t1+333; %n
p1=plot(t1:t2,V(t1:t2),'color',c1,'LineWidth',1.5); %hold on; % was V (Vcalc) % Observed (black)
p2=plot(t1:t2,V14(t1:t2),'Color',c2,'LineWidth',1.5); % (REG)
% p3=plot(t1:t2,V13(t1:t2),'Color', c3,'LineWidth',1.5);  % (MA)
p3=plot(t1:t2,V17(t1:t2),'Color', c3,'LineWidth',1.5);  % (REGa)
% p4=plot(t1:t2,V2(t1:t2) ,'Color', c4,'LineWidth',1.5); %  (LIN)
p4=plot(t1:t2,V15(t1:t2) ,'Color', c4,'LineWidth',1.5); %  (SSA)
p5=plot(t1:t2,V7(t1:t2),'Color',c5,'LineWidth',1.5); %hold off;  ...      %  (MKM)
p6=patch(t1:t2,V1(t1:t2),'b',...
      'FaceColor','none',...
      'EdgeColor',c6,...
      'EdgeAlpha',1,...
      'LineWidth',1.5);
ylabel(strcat('$V_{SW} \quad$', '[$km$ $s^{-1}$]'),'interpreter', "latex",'FontSize', 14); 
set(gca,'FontSize',14); xticks(t1:dt:t2); xticklabels([string(datetime(TdateV(t1:dt:t2),'Format',"dd-MMM, HH:mm"))]); xlabel('UT','FontSize', 14);
xlim([t1+667 t2]); ylim([300 800]); title('(c)','position',[t1+667-20, max(ylim), 0]); %V
% hold(ax1,'off');
ax6 = axes('Position',ax5.Position,'Color','none','XTick',[],'YTick',[],'Box','off');
xregion(find(diff([false; SWC_slow])==1)+t1-1,find(diff([SWC_slow;false])==-1)+t1-1,'FaceColor',colSlow,'EdgeColor','none'); %Light blue
xregion(find(diff([false; SWC_fast])==1)+t1,find(diff([SWC_fast;false])==-1)+t1,'FaceColor',colFast,'EdgeColor','none'); %Light yellow
% xregion(find(diff([false; SWC_compression])==1)+t1,find(diff([SWC_compression;false])==-1)+t1,'FaceColor',[1.00 0.55 0.20],'EdgeColor','none'); % Orange-red
% xregion(find(diff([false; SWC_rarefaction])==1)+t1,find(diff([SWC_rarefaction;false])==-1)+t1,'FaceColor',[0.55 0.65 1.00],'EdgeColor','none'); %Purple
xregion(find(diff([false; SWC_CIR])==1)+t1,find(diff([SWC_CIR;false])==-1)+t1,'FaceColor',colCIR,'EdgeColor','none'); % Orange-red
xregion(find(diff([false; SWC_shock_candidate])==1)+t1,find(diff([SWC_shock_candidate;false])==-1)+t1,'FaceColor',colShock,'EdgeColor',colShock,'LineWidth',1,'FaceAlpha',0.25); %muted red
xlim([t1+667 t2]);
