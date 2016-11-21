
% main function
clc; 
clear   %��� 
close all; %�ر�֮ǰ����

Size_Grid=10;  %������������С����λ��m  
Room_Length=Size_Grid; %����
Room_Width=Size_Grid;  %���
RUNS = 50; %%�������
scale=1;        %%%%%%%%%%%%%%%%%%%%%%%%%%%%�ɱ������GM�㷨�Ŀռ���ɢ������  ���񾫶ȣ�1/scale
Microphone_Distance=0.34; %�ֻ�������mic֮����� ��λm
measure_alpha=0.75;     %%%�и����
percent     = 0.9;      %���㶨λ���ʱ��ֻȡǰ90%���������10%
KNN=4;  %% Basic Hamming parameter ��Hamming������С��KNN����ȡƽ�����������������㷨�����������С��KNN��ȡƽ��ֵ
sample_rate=44100;% Sample/s
sound_speed=340;  %m/s


location_error_range_abs =0;         %%%%%%%%%%%%%%%%%%%%�ڵ�λ����Χ,��λm,���:100m

toa_time_error_range_abs=0;         % TOA������� ��λ ms   1000ms---340m   

tdoa_time_error_range_abs = 0;        % TDOA������� ��λ Sample   [-44 44]
angle_error_range_abs = 0;            %%%%%%%%%%%%%%%%%%%�ڵ�Ƕ���Χ,��λ�Ƕ�,���10�ȣ�Ĭ��ֵ5��

Node_Error_NUM_Percent=0.00;           %%%%%%%%%%%%%%%%%%%�ڵ�������Ϣ����İٷֱȣ����30%��Ĭ��ֵ5%
real_statics_run=floor(RUNS*percent);

anchor_min=30;   %��С�ڵ������Ĭ��ֵ30
anchor_max=10;  %���
anchor_gap=1;   %���
anchors=anchor_min:anchor_gap:anchor_max;  %%%%%%%%%%%%%%%%%%%%%%%%%%�ɱ������ʵ����ʹ�õĽ�����

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
        
        Microphone_Cita=fix(-90+180*(rand(Node_number,1))); %%���� [-90  90]    
        Microphone_Center_Location=fix(Size_Grid*abs((rand(Node_number,2)))); % ����λ��
        
        Microphone_1_Location=zeros(Node_number,2);
		Microphone_2_Location=zeros(Node_number,2);
		
        %%����ÿ���ֻ���������˷��λ��
        for  i=1:Node_number
        %%(L/2,0)
	    Microphone_1_Location(i,1)=Microphone_Center_Location(i,1) + 0.5*Microphone_Distance*(cos(Microphone_Cita(i)*pi/180));
        Microphone_1_Location(i,2)=Microphone_Center_Location(i,2) + 0.5*Microphone_Distance*(-sin(Microphone_Cita(i)*pi/180));  
		 %%(-L/2,0)
        Microphone_2_Location(i,1)=Microphone_Center_Location(i,1) - 0.5*Microphone_Distance*(cos(Microphone_Cita(i)*pi/180));
        Microphone_2_Location(i,2)=Microphone_Center_Location(i,2) - 0.5*Microphone_Distance*(-sin(Microphone_Cita(i)*pi/180));        
        end	 
          
  %�������˵����ʵ��λ�ã�������Ϣ����˵����λ����ʵ�ʽڵ�λ�ü���

 		measure_data=zeros(Node_number,1);  
        real_speaker_location=(Size_Grid*abs((rand(1,2)))); 
        speaker_x=real_speaker_location(1,1);
        speaker_y=real_speaker_location(1,2);        
       
        
        %%%��ʵ�ʽ��з���֮ǰ���һ���������         
        Microphone_Center_Location_with_error = Microphone_Center_Location + location_error_range_abs*2*(-0.5+rand(size(Microphone_Center_Location)));
        Microphone_Cita_with_error = Microphone_Cita + angle_error_range_abs*2*(-0.5+rand(size(Microphone_Cita)));  
        
        %%�������ĵ��볯�򣬼���������˷�λ��
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
                measure_data(i)=0;    %% 11.07��2015  ��֪Ϊ����Ҫ�������������ȷִ�У�����2��Сʱ�ҵ�������󣡣��� 
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
                    
        %%%%%%%�и����%%%
        measure_data_probability=ones(Node_number,1);        
        for i=1:Node_number
            measure_data_probability(i)=measure_alpha;
        end     
            
            
      % 		   		 %%%%%%%%%%%���� table_binary, ʵ�ʲ��ԣ��������� %%%%%%%%%%% 
 		 table_binary=zeros(Room_Width*scale*Room_Width*scale,Node_number+2);
         
         table_binary=creat_table(Microphone_Center_Location_with_error,Microphone_Cita_with_error,Microphone_Distance,Room_Width,Room_Length,scale,Node_number);
         Microphone_Center_Location_with_error;
         table_binary;
%          %ȡ��x��y������table_binary��С
%          [tb1,tb2]=size(table_binary);
%          table_xy=table_binary(1:100,tb2-1:tb2);
%          %ת��Ϊ2����
%          table_xy(:,1);
%          table_x=dec2bin(table_xy(:,1));
%          table_y=dec2bin(table_xy(:,2));
%          tbwww=bin2dec(table_x);%%�����ǲ����ַ��������ַ�������ת��10����
%          %�����Ƴ���
%          bin_length=length(table_x(1,:));%��ʱ����
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
         %x�Ķ�����ÿһλ�洢����ʱ�����á�
         %table_xx[bin_length];
         %for i = 0:bin_length-1
         %    table_xx[i]=table_x(:,i)
         %end
         measure_data_with_error';
         
         %��ŵͼ�����ĵ��÷���������
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


clear all  %��� 
close all; %�ر�֮ǰ����
load data.mat

%Drawing RMSE

%%������С��������ȡǰ90%
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



        

