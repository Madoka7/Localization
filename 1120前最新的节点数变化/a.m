
% main function
clc; 
clear   %清除 
close all; %关闭之前数据

Size_Grid=10;  %雷声监测区域大小，单位：m  
Room_Length=Size_Grid; %长度
Room_Width=Size_Grid;  %宽度
RUNS = 50; %%仿真次数
scale=1;        %%%%%%%%%%%%%%%%%%%%%%%%%%%%可变参数，GM算法的空间离散化步长  网格精度：1/scale
Microphone_Distance=0.34; %手机上两个mic之间距离 单位m
measure_alpha=0.75;     %%%切割概率
percent     = 0.9;      %计算定位误差时，只取前90%，舍掉最大的10%
KNN=4;  %% Basic Hamming parameter ，Hamming距离最小的KNN个点取平均，基本汉明距离算法所需参数，最小的KNN个取平均值
sample_rate=44100;% Sample/s
sound_speed=340;  %m/s


location_error_range_abs =0;         %%%%%%%%%%%%%%%%%%%%节点位置误差范围,单位m,最大:100m

toa_time_error_range_abs=0;         % TOA测量误差 单位 ms   1000ms---340m   

tdoa_time_error_range_abs = 0;        % TDOA测量误差 单位 Sample   [-44 44]
angle_error_range_abs = 0;            %%%%%%%%%%%%%%%%%%%节点角度误差范围,单位角度,最大10度，默认值5度

Node_Error_NUM_Percent=0.00;           %%%%%%%%%%%%%%%%%%%节点量测信息出错的百分比，最大30%，默认值5%
real_statics_run=floor(RUNS*percent);

anchor_min=30;   %最小节点个数，默认值30
anchor_max=10;  %最大
anchor_gap=1;   %间隔
anchors=anchor_min:anchor_gap:anchor_max;  %%%%%%%%%%%%%%%%%%%%%%%%%%可变参数，实验所使用的结点个数

estimated_speaker_location_final=zeros(RUNS,2);
 
for runs = 1:RUNS 
disp(['--------------------------------------------------------- ']);
    disp(['runs = ',num2str(runs)]);
	disp(['--------------------------------------------------------- ']);
     
    count=1;
     
    for Num_Achohor=anchor_min:anchor_gap:anchor_max
        Node_number =  Num_Achohor;
             disp(['Node_number = ',num2str(Node_number)]);
		disp(['************* ']); 
        
        Microphone_Cita=fix(-90+180*(rand(Node_number,1))); %%朝向 [-90  90]    
        Microphone_Center_Location=fix(Size_Grid*abs((rand(Node_number,2)))); % 中心位置
        
        Microphone_1_Location=zeros(Node_number,2);
		Microphone_2_Location=zeros(Node_number,2);
		
        %%计算每个手机上两个麦克风的位置
        for  i=1:Node_number
        %%(L/2,0)
	    Microphone_1_Location(i,1)=Microphone_Center_Location(i,1) + 0.5*Microphone_Distance*(cos(Microphone_Cita(i)*pi/180));
        Microphone_1_Location(i,2)=Microphone_Center_Location(i,2) + 0.5*Microphone_Distance*(-sin(Microphone_Cita(i)*pi/180));  
		 %%(-L/2,0)
        Microphone_2_Location(i,1)=Microphone_Center_Location(i,1) - 0.5*Microphone_Distance*(cos(Microphone_Cita(i)*pi/180));
        Microphone_2_Location(i,2)=Microphone_Center_Location(i,2) - 0.5*Microphone_Distance*(-sin(Microphone_Cita(i)*pi/180));        
        end	 
          
  %随机生成说话人实际位置，测量信息由是说话人位置与实际节点位置计算

 		measure_data=zeros(Node_number,1);  
        real_speaker_location=(Size_Grid*abs((rand(1,2)))); 
        speaker_x=real_speaker_location(1,1);
        speaker_y=real_speaker_location(1,2);        
       
        
        %%%在实际进行仿真之前添加一定量的误差         
        Microphone_Center_Location_with_error = Microphone_Center_Location + location_error_range_abs*2*(-0.5+rand(size(Microphone_Center_Location)));
        Microphone_Cita_with_error = Microphone_Cita + angle_error_range_abs*2*(-0.5+rand(size(Microphone_Cita)));  
        
        %%根据中心点与朝向，计算两个麦克风位置
        for i = 1 : Node_number
            Microphone_1_Location_with_error(i,1)=Microphone_Center_Location_with_error(i,1) + 0.5*Microphone_Distance*(cos(Microphone_Cita_with_error(i)*pi/180));
            Microphone_1_Location_with_error(i,2)=Microphone_Center_Location_with_error(i,2) + 0.5*Microphone_Distance*(-sin(Microphone_Cita_with_error(i)*pi/180));  
         
            Microphone_2_Location_with_error(i,1)=Microphone_Center_Location_with_error(i,1) - 0.5*Microphone_Distance*(cos(Microphone_Cita_with_error(i)*pi/180));
            Microphone_2_Location_with_error(i,2)=Microphone_Center_Location_with_error(i,2) - 0.5*Microphone_Distance*(-sin(Microphone_Cita_with_error(i)*pi/180));
        end    
		
      begin_time=0;
      for i=1:Node_number    
      distance_tmp(i)= (norm(real_speaker_location-Microphone_1_Location(i,:),2) + norm(real_speaker_location-Microphone_2_Location(i,:),2))/2;
         toa_data(i)= begin_time + distance_tmp(i)/sound_speed;
      end
      
      
        for i=1:Node_number    
       toa_data_with_error(i)= toa_data(i) + round(0.001*toa_time_error_range_abs*2*(-0.5+rand(1,1)));
        end
        
	tdoa_data=zeros(Node_number,1);  
  for i=1:Node_number    
      distance_different(i)= norm(real_speaker_location-Microphone_1_Location(i,:),2) - norm(real_speaker_location-Microphone_2_Location(i,:),2);
      
    % distance_different(i)=sqrt(((real_speaker_location(1)-Microphone_1_Location(i,1)).^2)+((real_speaker_location(2)-Microphone_1_Location(i,2)).^2))-sqrt(((real_speaker_location(1)-Microphone_2_Location(i,1)).^2)+((real_speaker_location(2)-Microphone_2_Location(i,2)).^2));
          
      tdoa_data(i)= round(distance_different(i)*sample_rate/sound_speed);
  end
  

  	tdoa_data_with_error=zeros(Node_number,1);  
    for i=1:Node_number    
      tdoa_data_with_error(i)= tdoa_data(i) + round(tdoa_time_error_range_abs*2*(-0.5+rand(1,1)));
    end
        
  measure_data=zeros(Node_number,1); 
        for i=1:Node_number
            tmp = tdoa_data(i);
            if tmp>0
                measure_data(i)=0;    %% 11.07，2015  不知为何需要这样定义才能正确执行，用了2个小时找到这个错误！！！ 
            else
                measure_data(i)=1;  %%%
            end
        end     
        
   measure_data_with_error=zeros(Node_number,1); 
        measure_data_with_error=measure_data;	
             
        temp2=randperm(Node_number);		 
		Node_Error_NUM=floor(Node_Error_NUM_Percent*Node_number);
		err_node=temp2(1:Node_Error_NUM);        
		    for i=1:Node_Error_NUM
                if measure_data_with_error(err_node(1,i))==0
                    measure_data_with_error(err_node(1,i))=1;
                else
                    measure_data_with_error(err_node(1,i))=0;
                end
            end                   
                    
        %%%%%%%切割概率%%%
        measure_data_probability=ones(Node_number,1);        
        for i=1:Node_number
            measure_data_probability(i)=measure_alpha;
        end     
            
            
      % 		   		 %%%%%%%%%%%建表 table_binary, 实际测试，建表无误差？ %%%%%%%%%%% 
 		 table_binary=zeros(Room_Width*scale*Room_Width*scale,Node_number+2);
         
         table_binary=creat_table(Microphone_Center_Location_with_error,Microphone_Cita_with_error,Microphone_Distance,Room_Width,Room_Length,scale,Node_number);
         Microphone_Center_Location_with_error;
         table_binary;
%          %取出x和y，计算table_binary大小
%          [tb1,tb2]=size(table_binary);
%          table_xy=table_binary(1:100,tb2-1:tb2);
%          %转换为2进制
%          table_xy(:,1);
%          table_x=dec2bin(table_xy(:,1));
%          table_y=dec2bin(table_xy(:,2));
%          tbwww=bin2dec(table_x);%%测试是不是字符串；是字符串；能转成10进制
%          %二进制长度
%          bin_length=length(table_x(1,:));%暂时不用
%          
%          table_x3=table_x(:,1);
%          table_x;
%          table_x2=table_x(:,2);
%          table_x1=table_x(:,3);
%          table_x0=table_x(:,4);
%          
%          x3_seq=[];x2_seq=[];x1_seq=[];x0_seq=[];
%          %c=0;
%          for i=1:100
%             % table_x3(1:i)
%             %table_binary(i,1:5)
%             %table_x3(i)
%              if table_x3(i)=='1'
%                  %'help'
%                  %c=c+1;
%                  x3_seq=[x3_seq; table_binary(i,1:5)];
%              end
%              if table_x2(i)=='1'
%                  x2_seq=[x2_seq; table_binary(i,1:5)];
%              end
%              if table_x1(i)=='1'
%                  x1_seq=[x1_seq; table_binary(i,1:5)];
%              end
%              if table_x0(i)=='1'
%                  x0_seq=[x0_seq; table_binary(i,1:5)];
%              end
%              
%          end
%          c=x2_seq(1,:);
%          b=x3_seq(1,:);
%          a=uX(x3_seq,b);
%          d=uX(x2_seq,c);
%          e=uX(x1_seq,b);
%          
         %[M,N]=size(x3_seq)
        %%d
        % e
         %c
         %x3_seq
         %x的二进制每一位存储，暂时不能用。
         %table_xx[bin_length];
         %for i = 0:bin_length-1
         %    table_xx[i]=table_x(:,i)
         %end
         measure_data_with_error';
         
         %卡诺图函数的调用发生在这里
         [a,b]=Karnaugh_Map_Prediction(table_binary,measure_data_with_error')
         real_speaker_location(:)
         return;
              
        %%%%%% TDOA 
     
       estimated_location_tdoa= TDOA_Tanqing(Microphone_1_Location_with_error,Microphone_2_Location_with_error,Node_number,tdoa_data_with_error,speaker_x,speaker_y);
       rmse_TDOA_tmp(count) = sqrt( sum((real_speaker_location(:)-estimated_location_tdoa(:)).^2) )  %
       
  
        %%%%%% TOA
        estimated_location_toa= TOA_Method(Microphone_1_Location_with_error,Microphone_2_Location_with_error,Node_number,toa_data_with_error,speaker_x,speaker_y);
        rmse_TOA_tmp(count) = sqrt( sum((real_speaker_location(:)-estimated_location_toa(:)).^2) );  %
            
        estimated_location=Hamming_Distance_Method(measure_data_with_error',table_binary,KNN);        
		rmse_Hamming_tmp(count) = sqrt( sum((real_speaker_location(:)-estimated_location(:)).^2) );  %
    %    rmse_Hamming_tmp(count)=0;
        
        estimated_location=Advanced_Hamming_Distance_Method(measure_data_with_error',table_binary); 
		rmse_Advanced_Hamming_tmp(count) = sqrt( sum((real_speaker_location(:)-estimated_location(:)).^2) );  %
   % rmse_Advanced_Hamming_tmp(count)=0;
    
     estimated_location_2= GM_Probility_Cutting(Node_number,measure_data_with_error,measure_data_probability,Microphone_1_Location_with_error,Microphone_2_Location_with_error,Size_Grid,scale);
     rmse_Probility_Cutting_tmp(count) = sqrt( sum((real_speaker_location(:)-estimated_location_2(:)).^2) );  % 
		        
        count=count+1;
        
    end
    rmse_TOA_final_Anchors(runs,:)=rmse_TOA_tmp;
    rmse_TDOA_final_Anchors(runs,:)=rmse_TDOA_tmp;    
    rmse_Hamming_final_Anchors(runs,:)=rmse_Hamming_tmp;
	rmse_Advanced_Hamming_final_Anchors(runs,:)=rmse_Advanced_Hamming_tmp;
    rmse_Probility_Cutting_final_Anchors(runs,:)=rmse_Probility_Cutting_tmp; 
end

save data.mat  rmse_Probility_Cutting_final_Anchors  rmse_Advanced_Hamming_final_Anchors  rmse_TDOA_final_Anchors real_statics_run anchors...
               rmse_TOA_final_Anchors rmse_Hamming_final_Anchors...
               Room_Length  Room_Width  RUNS scale Microphone_Distance Microphone_Distance percent KNN sample_rate sound_speed...
               tdoa_time_error_range_abs  location_error_range_abs angle_error_range_abs Node_Error_NUM_Percent


clear all  %清除 
close all; %关闭之前数据
load data.mat

%Drawing RMSE

%%将误差从小到大排序，取前90%
[A,B]=sort(rmse_TOA_final_Anchors);
rmse_TOA_MC = mean(A(1:real_statics_run,:));

[A,B]=sort(rmse_TDOA_final_Anchors);
rmse_TDOA_MC = mean(A(1:real_statics_run,:));


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
plot(anchors, rmse_TOA_MC, 'rp-', 'LineWidth', 2, 'MarkerFaceColor', 'r');
plot(anchors, rmse_TDOA_MC, 'kh-', 'LineWidth', 2, 'MarkerFaceColor', 'k');


hold off
legend('\fontsize{12}\bf Hamming','\fontsize{12}\bf WHamming','\fontsize{12}\bf PCM' ,'\fontsize{12}\bf TOA','\fontsize{12}\bf TDOA' );

xlabel('\fontsize{12}\bf Number of Node');
ylabel('\fontsize{12}\bf Localization Error(m)');
title('\fontsize{12}\bf  Localization Error vs. Number of Anchors');



        

