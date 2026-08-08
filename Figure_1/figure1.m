% Figure 1.
% Data
% OMNI
url = 'https://spdf.gsfc.nasa.gov/pub/data/omni/low_res_omni/omni2_all_years.dat';
filename = 'omni2_all_years.dat';
websave(filename, url);
load omni2_all_years.dat -ascii;
Tdate=datetime(omni2_all_years(1:end,1),month(omni2_all_years(1:end,2)),day(omni2_all_years(1:end,2)),omni2_all_years(1:end,3),0,0  );
% Hp60
websave('Hp60.txt', 'https://kp.gfz.de/app/hpodata?startdate=1995-01-01&enddate=2025-06-02&format=Hp60_txt#hpo-data-download-207');
load Hp60.txt -ascii;


% SpaceCrafts
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
SP2 = array2table(SP2,'VariableNames', {'ID','Tst','Ted'}); SP2(find(ismember(SP2.ID, {'52', '45','47'})),:)=[]; % the same as 51 and 52


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
R=omni2_all_years(:,40); R(find(R==999))=NaN;


% IMF and SW Plasma Spacecraft + Data available
fig1=figure(1); fig1.Position=[50 50 800 1200];
subplot(2,1,1); 
SP.Tst = datetime(SP.Tst, "InputFormat", "dd-MM-yyyy");
SP2.Tst = datetime(SP2.Tst, "InputFormat", "dd-MM-yyyy");
SP2.ID(find(SP2.ID=='44'))='47'; S=outerjoin(SP,SP2,'Keys','ID'); 
S.Order = S.Tst_SP; S.Order(isnat(S.Order)) = S.Tst_SP2(isnat(S.Order));
S = sortrows(S, {'Order'}, {'ascend'});
% fig2=figure(2); fig2.Position=[50 50 800 400];
plot(Tdate,R,'Color',[0.7529 0.7529 0.7529]);
xlabel('Year',"FontSize",14); set(gca,'FontSize',14); % colors = lines(15);
ylabel('Sunspot Number',"FontSize",14); 
colors = 0.5 + 0.5*parula(length(S.ID_SP)); ylim([0 600]); colorsL=repmat(flipud(linspace(0,0.1,length(S.ID_SP))'), 1,3);  %flipud() colorsL = turbo(length(SP2.ID)) 
for i=1:length(S.ID_SP)
tst=datetime(S.Tst_SP(i),"InputFormat",'dd-MM-yyyy');
ted=datetime(S.Ted_SP(i),"InputFormat",'dd-MM-yyyy');
yst=80+(i-1)*25;
yed=100+(i-1)*25;
patch([tst ted ted tst],[yst yst yed yed],colors(i,:), 'EdgeColor','none');
text(tst,yst+10, S.Spacecraft_Name2_SP(i),"FontSize",12,'Color',colorsL(i,:));
end
text(min(xlim), max(ylim)*1.1, '(a)', 'HorizontalAlignment', 'left','VerticalAlignment', 'top','FontWeight', 'bold','FontSize', 14);
% colors = 0.5 + 0.5*parula(length(S.ID_SP));
for i=1:length(S.ID_SP)
tst=datetime(S.Tst_SP2(i),"InputFormat",'dd-MM-yyyy');
ted=datetime(S.Ted_SP2(i),"InputFormat",'dd-MM-yyyy');
yst=80+(i-1)*25;
yed=100+(i-1)*25;
patch([tst ted ted tst],[yst yst yed yed],colors(i,:), 'EdgeColor','none');
text(tst,yst+10, S.Spacecraft_Name2_SP2(i),"FontSize",12);
end

% load Hp60.txt -ascii;
TdateHp60=datetime(Hp60(1:end,1),month(Hp60(1:end,2)),day(Hp60(1:end,2)),Hp60(1:end,3),0,0  ); 
GV=abs([0;find(omni2_all_years(:,25)~=9999)]-[find(omni2_all_years(:,25)~=9999);length(omni2_all_years)]); GV=repelem(GV, max(GV,1))<2; GV=double(GV); GV(~GV) = NaN;
Gn=abs([0;find(omni2_all_years(:,24)~=999.9)]-[find(omni2_all_years(:,24)~=999.9);length(omni2_all_years)]); Gn=repelem(Gn, max(Gn,1))<2; Gn=double(Gn); Gn(~Gn) = NaN;
GB=abs([0;find(omni2_all_years(:,10)~=999.9)]-[find(omni2_all_years(:,10)~=999.9);length(omni2_all_years)]); GB=repelem(GB, max(GB,1))<2; GB=double(GB); GB(~GB) = NaN;
GT=abs([0;find(omni2_all_years(:,23)~=9999999)]-[find(omni2_all_years(:,23)~=9999999);length(omni2_all_years)]); GT=repelem(GT, max(GT,1))<2; GT=double(GT); GT(~GT) = NaN;
GKp=abs([0;find(omni2_all_years(:,39)~=99)]-[find(omni2_all_years(:,39)~=99);length(omni2_all_years)]); GKp=repelem(GKp, max(GKp,1))<2; GKp=double(GKp); GKp(~GKp) = NaN;
GDst=abs([0;find(omni2_all_years(:,41)~=99999)]-[find(omni2_all_years(:,41)~=99999);length(omni2_all_years)]); GDst=repelem(GDst, max(GDst,1))<2; GDst=double(GDst); GDst(~GDst) = NaN;
GAE=abs([0;find(omni2_all_years(:,42)~=9999)]-[find(omni2_all_years(:,42)~=9999);length(omni2_all_years)]); GAE=repelem(GAE, max(GAE,1))<2; GAE=double(GAE); GAE(~GAE) = NaN;
GHp60=repelem(1,length(Hp60(:,8) ) )';

subplot(2,1,2); 
% colors = lines(7);
plot(Tdate,R,'Color',[0.7529 0.7529 0.7529]); ylim([0 600]); hold on;
xlabel('Year',"FontSize",14); set(gca,'FontSize',14); 
ylabel('Sunspot Number',"FontSize",14); text(min(xlim), max(ylim)*1.1, '(b)', 'HorizontalAlignment', 'left','VerticalAlignment', 'top','FontWeight', 'bold','FontSize', 14);
plot(Tdate,550*GV,'Color', colors(17,:),'LineWidth', 10); text(Tdate(400000),550, '$V_{SW}$ [km $s^{-1}$]','interpreter','latex',"FontSize",12);
plot(Tdate,500*Gn, 'Color', colors(15,:),'LineWidth', 10); text(Tdate(400000),500, '$n$ [N $sm^{-3}$]','interpreter','latex',"FontSize",12);
plot(Tdate,450*GB, 'Color', colors(13,:),'LineWidth', 10); text(Tdate(400000),450, '$|B|$ [$nT$]','interpreter','latex',"FontSize",12);
% plot(Tdate,400*GT, 'Color', colors(11,:),'LineWidth', 10); text(Tdate(400000),400, '$Tp$ [$K$]','interpreter','latex',"FontSize",12);
plot(Tdate,400*GKp,'Color', colors(9,:),'LineWidth', 10); text(Tdate(400000),400, '$Kp$','interpreter','latex',"FontSize",12);
plot(Tdate,350*GDst,'Color', colors(7,:),'LineWidth', 10); text(Tdate(400000),350, '$Dst$ [$nT$]','interpreter','latex',"FontSize",12);
plot(Tdate,300*GAE,'Color', colors(5,:),'LineWidth',10); text(Tdate(400000),300, '$AE$ [$nT$]','interpreter','latex',"FontSize",12);
plot(TdateHp60, 250*GHp60,'Color', colors(1,:),'LineWidth',10); text(Tdate(400000),250, '$Hp60$','interpreter','latex',"FontSize",12);
hold off;
