disp(['Saving and Drawing................. ']);
save data.mat    rmse_Probility_Cutting_final_Anchors rmse_Advanced_Hamming_final_Anchors rmse_Hamming_final_Anchors  anchors real_statics_run  location_error_range_abs angle_error_range_abs   Node_Error_NUM_Percent Room_Length  Room_Width RUNS scale Microphone_Distance  measure_alpha  percent KNN
clear all;
load data.mat


%Drawing RMSE

%%将误差从小到大排序，取前90%
[A,B]=sort(rmse_Hamming_final_Anchors);
rmse_Hamming_MC = mean(A(1:real_statics_run,:));

[A,B]=sort(rmse_Advanced_Hamming_final_Anchors);
rmse_Advanced_Hamming_MC = mean(A(1:real_statics_run,:));

[A,B]=sort(rmse_Probility_Cutting_final_Anchors);
rmse_Probility_Cutting_MC = mean(A(1:real_statics_run,:));


figure('Position',[1 1 1200 900])
figure(1);
 plot(anchors, rmse_Hamming_MC, 'rs-', 'LineWidth', 2, 'MarkerFaceColor', 'r');
 hold on;
  plot(anchors, rmse_Advanced_Hamming_MC, 'g^-', 'LineWidth', 2, 'MarkerFaceColor', 'g');
 plot(anchors, rmse_Probility_Cutting_MC, 'bd-', 'LineWidth', 2, 'MarkerFaceColor', 'b');%
hold off
legend('\fontsize{12}\bf Basic Hamming','\fontsize{12}\bf Advanced Hamming','\fontsize{12}\bf Probility Cutting');

xlabel('\fontsize{12}\bf Number of Node');
ylabel('\fontsize{12}\bf Localization Error(in units)');
title('\fontsize{12}\bf  Localization Error vs. Number of Anchors');


%%%%%%%%%%%draw cdf
figure(2);
[y0,x0]=ecdf(rmse_Hamming_MC);
[y1,x1] = ecdf(rmse_Advanced_Hamming_MC);
[y2,x2] = ecdf(rmse_Probility_Cutting_MC);

plot(x0,y0, 'rs-', 'LineWidth', 2)
hold on
plot(x1,y1, 'gd-', 'LineWidth', 2)

plot(x2,y2, 'b^-', 'LineWidth', 2)
%legend('\fontsize{12}\bf y1','\fontsize{12}\bf y2','Location','NW');
legend('\fontsize{12}\bf Basic Hamming','\fontsize{12}\bf Advanced Hamming','\fontsize{12}\bf Probility Cutting','Location','NW');
xlabel('\fontsize{12}\bf RMSE');
ylabel('\fontsize{12}\bf CDF');
title('\fontsize{12}\bf  RMSE vs. CDF');





