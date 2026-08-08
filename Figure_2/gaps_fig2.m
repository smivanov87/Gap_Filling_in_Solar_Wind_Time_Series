function [h1] = gaps_fig2(gaps,gaps1994,gaps2025,Var1,subplt,xpnt)
% 
color1=[0, 0.4470, 0.7410];
color2=[0.8500, 0.3250, 0.0980];
color3=[0.4940, 0.1840, 0.5560];
color4=[0.4660, 0.6740, 0.1880];
color5=[0, 0.5, 0];
color6=[0.25, 0.25, 0.25];
color7=[0.753, 0.753, 0.753];
Dgaps=tabulate(gaps(:,4));
Dgaps1994=tabulate(gaps1994(:,4));
% Dgaps2005=tabulate(gaps2005(:,4));
Dgaps2025=tabulate(gaps2025(:,4));
h1=subplot(3,1,subplt); 
fig1=figure(1);
fig1.Position=[50 50 800 800];
% h1 = histogram(gaps(:,4),1:1:25,Normalization="percentage");ytickformat("percentage"); hold on;
% h2 = histogram(gaps1985(:,4),1:1:25,Normalization="percentage" );ytickformat("percentage");  hold on;
% h3 = histogram(gaps2005(:,4),1:1:25,Normalization="percentage" );ytickformat("percentage"); hold on;
% h4 = histogram(gaps2025(:,4),1:1:25,Normalization="percentage" );ytickformat("percentage"); hold off;
% h1.FaceColor=color4;h2.FaceColor=color2;h3.FaceColor=color3;h4.FaceColor=color1;
% h1.FaceAlpha=0.5; h2.FaceAlpha=0.5; h3.FaceAlpha=0; h4.FaceAlpha=0; 
stem(Dgaps(:,1), Dgaps(:,2),'-o', 'LineWidth',1,'MarkerSize',15,'MarkerEdgeColor',color7,'MarkerFaceColor',color7,'Color',color7 ); hold on;
% stem(Dgaps1985(:,1), Dgaps1985(:,2),'-o', 'LineWidth',1,'MarkerSize',12,'MarkerEdgeColor',color2,'MarkerFaceColor',color2,'Color',color2 );
% stem(Dgaps2005(:,1), Dgaps2005(:,2),'-o', 'LineWidth',1,'MarkerSize',8,'MarkerEdgeColor',color3,'MarkerFaceColor',color3,'Color',color3 );
stem(Dgaps1994(:,1), Dgaps1994(:,2),'-o', 'LineWidth',1,'MarkerSize',5,'MarkerEdgeColor',color3,'MarkerFaceColor',color3,'Color',color3);
stem(Dgaps2025(:,1), Dgaps2025(:,2),'-o', 'LineWidth',1,'MarkerSize',8,'MarkerEdgeColor',color1,'MarkerFaceColor',color1,'Color',color1 );
set(gca,'FontSize',14); set(gca, 'YScale', 'log');
% ylabel('Quantity','Interpreter','latex', 'FontSize', 14);  %
% yticks(0:2:42);
if xpnt==1
xticks(1:1:25);
xticklabels({'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25+ hours'}); %xtickformat("%g h");
xlabel('Length of Gap (Hours)', 'FontSize', 14);
end

if xpnt==0
set(gca,'xtick',[]);
end

if subplt==1
% ylabel({'(a)', 'number of gaps'},'Interpreter','latex', 'FontSize', 16);
ylabel('Number of Gaps','Interpreter','latex', 'FontSize', 16);
title('(a)','position',[-1.5, max(ylim), 0]);
legend('Jun1965-May2025: 525 770 hrs','Jun1965-Dec1994: 259 320 hrs', 'Jan1995-May2025: 266 450 hrs','Interpreter','latex','FontSize',14);
legend('boxoff'); 
elseif subplt==2
    % ylabel({'(b)', 'number of gaps'},'Interpreter','latex', 'FontSize', 16);
    ylabel('Number of Gaps','Interpreter','latex', 'FontSize', 16);
    title('(b)','position',[-1.5, max(ylim), 0]);
    elseif subplt==3
        % ylabel({'(c)', 'number of gaps'},'Interpreter','latex', 'FontSize', 16);
        ylabel('Number of Gaps','Interpreter','latex', 'FontSize', 16);
        title('(c)','position',[-1.5, max(ylim), 0]);
end
% text(2,2900, strcat('$V_{SW}:Nov1963-May2025(539030 hours)$; $\quad E=$',num2str(round( mean(gaps(:,1)),0 )),'h;','$\quad \sigma^2=$',num2str(round(var(gaps(:,1),1),0)),';' ),'Interpreter','latex', 'FontSize', 14,'Color',color1);
% text(2,27, strcat('Coefficient of variation:','$\quad C_v=$',num2str(round( sqrt(var(gaps(:,1),1))/abs(mean(gaps(:,1) ) ) ,2 )),';'),'Interpreter','latex', 'FontSize', 14,'Color',color1)
% text(2,25, strcat('Skewness:','$\quad S=$',num2str(round( mean((gaps(:,1)-mean(gaps(:,1))).^3)/sqrt(var(gaps(:,1)))^3 ,2 )),';'),'Interpreter','latex', 'FontSize', 14,'Color',color1)
% text(11,25, strcat('Kurtosis:','$\quad K=$',num2str(round( mean( (gaps(:,1)-mean(gaps(:,1) )).^4 )/sqrt(var(gaps(:,1) ))^4 ,2)),';'),'Interpreter','latex', 'FontSize', 14,'Color',color1)
% text(40,14, '$K(R)\\>3 \\|=> Leptokurtic \quad type$ ','Interpreter','latex', 'FontSize', 14)
% kurtosis(gaps(:,1))
% skewness(gaps(:,1))
% text(Dgaps(:,1), Dgaps(:,2)+50, sprintfc('%d',Dgaps(:,2)), 'HorizontalAlignment','center', 'VerticalAlignment','bottom','FontSize', 13);
% text(Dgaps1985([1:3 end],1), Dgaps1985([1:3 end],2)+40, sprintfc('%d',Dgaps1985([1:3 end],2)), 'HorizontalAlignment','center', 'VerticalAlignment','bottom','FontSize', 13);
% text(Dgaps2005([1:3 end],1), Dgaps2005([1:3 end],2)+20, sprintfc('%d',Dgaps2005([1:3 end],2)), 'HorizontalAlignment','center', 'VerticalAlignment','bottom','FontSize', 13);
% text(Dgaps2025([1:3 end],1), Dgaps2025([1:3 end],2)+20, sprintfc('%d',Dgaps2025([1:3 end],2)), 'HorizontalAlignment','center', 'VerticalAlignment','bottom','FontSize', 13);
% legend({[strcat('$',Var1,'(Nov1963-May2025:539030 hrs):Gaps: \quad E=$',num2str(round( mean(gaps(:,1)),0 )),'h;','$\quad \sigma^2=$',num2str(round(var(gaps(:,1),1),0)),';') ...
%     newline strcat('Coefficient of variation:','$\quad C_v=$',num2str(round( sqrt(var(gaps(:,1),1))/abs(mean(gaps(:,1) ) ) ,2 )),';') ...
%      strcat('$\quad$', 'Skewness:','$\quad S=$',num2str(round( mean((gaps(:,1)-mean(gaps(:,1))).^3)/sqrt(var(gaps(:,1)))^3 ,2 )),';',...
%               '$\quad$', 'Kurtosis:','$\quad K=$',num2str(round( mean( (gaps(:,1)-mean(gaps(:,1) )).^4 )/sqrt(var(gaps(:,1) ))^4 ,2)),';')...
%     ], ...
%     [strcat('$',Var1,'(Nov1963-Dec1985:193693 hrs):Gaps: \quad E=$',num2str(round( mean(gaps1985(:,1)),0 )),'h;','$\quad \sigma^2=$',num2str(round(var(gaps1985(:,1),1),0)),';') ...
%     newline strcat('Coefficient of variation:','$\quad C_v=$',num2str(round( sqrt(var(gaps1985(:,1),1))/abs(mean(gaps1985(:,1) ) ) ,2 )),';') ...
%     strcat('$\quad$', 'Skewness:','$\quad S=$',num2str(round( mean((gaps1985(:,1)-mean(gaps1985(:,1))).^3)/sqrt(var(gaps1985(:,1)))^3 ,2 )),';',...
%               '$\quad$', 'Kurtosis:','$\quad K=$',num2str(round( mean( (gaps1985(:,1)-mean(gaps1985(:,1) )).^4 )/sqrt(var(gaps1985(:,1) ))^4 ,2)),';')...
%     ], ...
%     [strcat('$',Var1,'(Jan1986-Dec2005:175320 hrs):Gaps: \quad E=$',num2str(round( mean(gaps2005(:,1)),0 )),'h;','$\quad \sigma^2=$',num2str(round(var(gaps2005(:,1),1),0)),';') ...
%     newline strcat('Coefficient of variation:','$\quad C_v=$',num2str(round( sqrt(var(gaps2005(:,1),1))/abs(mean(gaps2005(:,1) ) ) ,2 )),';') ...
%     strcat('$\quad$', 'Skewness:','$\quad S=$',num2str(round( mean((gaps2005(:,1)-mean(gaps2005(:,1))).^3)/sqrt(var(gaps2005(:,1)))^3 ,2 )),';',...
%               '$\quad$', 'Kurtosis:','$\quad K=$',num2str(round( mean( (gaps2005(:,1)-mean(gaps2005(:,1) )).^4 )/sqrt(var(gaps2005(:,1) ))^4 ,2)),';')...
%     ], ...
%     [strcat('$',Var1,'(Jan2006-May2025:170017 hrs):Gaps: \quad E=$',num2str(round( mean(gaps2025(:,1)),0 )),'h;','$\quad \sigma^2=$',num2str(round(var(gaps2025(:,1),1),0)),';') ...
%     newline strcat('Coefficient of variation:','$\quad C_v=$',num2str(round( sqrt(var(gaps2025(:,1),1))/abs(mean(gaps2025(:,1) ) ) ,2 )),';') ...
%     strcat('$\quad$', 'Skewness:','$\quad S=$',num2str(round( mean((gaps2025(:,1)-mean(gaps2025(:,1))).^3)/sqrt(var(gaps2025(:,1)))^3 ,2 )),';',...
%               '$\quad$', 'Kurtosis:','$\quad K=$',num2str(round( mean( (gaps2025(:,1)-mean(gaps2025(:,1) )).^4 )/sqrt(var(gaps2025(:,1) ))^4 ,2)),';')...
%     ],...
%     }, ...
%     'Interpreter','latex','FontSize',13,'BackgroundAlpha',0,'Location','northeast');
text(4, Dgaps(1,2)+100, strcat('$',Var1,'$'),'Interpreter','latex','FontSize',14);
hold off;

end