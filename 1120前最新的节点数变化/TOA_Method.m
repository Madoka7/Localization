function ww=TOA_Method(Microphone_1_Location,Microphone_2_Location,Node_number,toa_with_error,speaker_x,speaker_y)

x0=[speaker_x,speaker_y];
ww=fminsearch(@(x) myfunction(x,Microphone_1_Location,Microphone_2_Location,Node_number,toa_with_error),x0);


function f=myfunction(x,Microphone_1_Location,Microphone_2_Location,Node_number,toa_with_error)
f=0;
for i=1:Node_number
 s_M1= sqrt((Microphone_1_Location(i,1)-x(1))^2+(Microphone_1_Location(i,2)-x(2))^2);  
 s_M2= sqrt((Microphone_2_Location(i,1)-x(1))^2+(Microphone_2_Location(i,2)-x(2))^2);  
 Distance_Means = (s_M1 + s_M2)/2;
 f = f +( Distance_Means - toa_with_error(i)*340)^2;
end
 
