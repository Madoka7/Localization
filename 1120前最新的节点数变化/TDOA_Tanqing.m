function ww=TDOA_Tanqing(Microphone_1_Location,Microphone_2_Location,Node_number,tdoa_with_error,speaker_x,speaker_y)

x0=[speaker_x,speaker_y];
ww=fminsearch(@(x) myfunction(x,Microphone_1_Location,Microphone_2_Location,Node_number,tdoa_with_error),x0);


function f=myfunction(x,Microphone_1_Location,Microphone_2_Location,Node_number,tdoa_with_error)
f=0;
for i=1:Node_number
 s_M1= sqrt((Microphone_1_Location(i,1)-x(1))^2+(Microphone_1_Location(i,2)-x(2))^2);  
 s_M2= sqrt((Microphone_2_Location(i,1)-x(1))^2+(Microphone_2_Location(i,2)-x(2))^2);  
 f = f +( s_M1 - s_M2 - tdoa_with_error(i)*340/44100)^2;
end
 
