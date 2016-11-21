figure(1)
y1=10*rand(1,100);
y2=10*rand(1,100);


 [f1,x1] = ecdf(y1);
 [f2,x2] = ecdf(y2);

figure(1)
[AX,H1,H2] = plotyy(x1,f1,x2,f2,'plot');
set(AX(1),'XColor','k','YColor','b');
set(AX(2),'XColor','k','YColor','r');
HH1=get(AX(1),'Ylabel');
set(HH1,'String','Left Y-axis');
set(HH1,'color','b');
HH2=get(AX(2),'Ylabel');
set(HH2,'String','Right Y-axis');
set(HH2,'color','r');
set(H1,'LineStyle','-');
set(H1,'color','b');
set(H2,'LineStyle',':');
set(H2,'color','r');

figure(2)
 cdfplot(y1);
 hold on
 cdfplot(y2);


 figure(3)
[f1,x1] = ecdf(y1);
[f2,x2] = ecdf(y2);


plot(x1,f1, 'rd-', 'LineWidth', 1, 'MarkerFaceColor', 'r')
hold on
plot(x2,f2, 'bs-', 'LineWidth', 1, 'MarkerFaceColor', 'b')
legend('\fontsize{12}\bf y1','\fontsize{12}\bf y2','Location','NW');
xlabel('\fontsize{12}\bf RMSE');
ylabel('\fontsize{12}\bf CDF');
title('\fontsize{12}\bf  RMSE vs. CDF');