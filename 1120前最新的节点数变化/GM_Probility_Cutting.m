function [return_value]=GM_Probility_Cutting(Node_number,measure_data,measure_data_probability,Microphone_1_Location,Microphone_2_Location,Size_Grid,scale)

Room_Width=Size_Grid;
Room_Length=Size_Grid;
 
step=scale;  %���Բ���		
		
Mic_vector=Microphone_1_Location-Microphone_2_Location;
Room_tag=zeros(Room_Length*step,Room_Width*step); %��¼�����ڵ��Ƿ�������� 1Ϊ���� 0Ϊ������
Room_tag=Incise_probability(Node_number,measure_data,measure_data_probability,Mic_vector,Microphone_1_Location,Microphone_2_Location,Size_Grid,scale);

[x,y]=Coordinate2(Room_tag,Size_Grid,scale);

estimated_location=[x y];
return_value=estimated_location;