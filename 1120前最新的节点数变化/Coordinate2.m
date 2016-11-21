function [x,y]=Coordinate2(Room_tag,Size_Grid,scale)

Room_Length=Size_Grid;
Room_Width=Size_Grid; 
step=scale;  %测试步长
xmax=0;
ymax=0;
max_weight=max(max(Room_tag));

x=0;
y=0;

counter=0;
 %计算最终剩余点区域的几何中点，作为定位的坐标
for x_i=1:Room_Width*step
	for y_j=1:Room_Length*step
	
     %   if abs(Room_tag(x_i,y_j)-max_weight)<0.00001 %%%%by naigao 2015.11.8
      if abs(Room_tag(x_i,y_j)-max_weight)<1.0e-10 %%%%by naigao 2015.11.8
            counter=counter+1;
            xmax=xmax+x_i/step;
            ymax=ymax+y_j/step;
        end		
		
    end
end


    x=xmax/counter;
    y=ymax/counter;


end