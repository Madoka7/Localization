tx=1;
ty=0;
tz=0;
alpha=0;
beta=-pi/4;
gama=0;

T=[1 0 0 0;
   0 1 0 0;
   0 0 1 0; 
   tx ty tz 1];

Rx=[1 0 0 0;
    0 cos(alpha) sin(alpha) 0;
    0 -sin(alpha) cos(alpha) 0
    0 0 0 1];

Ry=[cos(beta) 0 -sin(beta) 0;
    0 1 0 0;
    sin(beta) 0 cos(beta) 0;
    0 0 0 1;];

Rz=[cos(gama) sin(gama) 0 0;
    -sin(gama) cos(gama) 0 0;
    0 0 1 0;
    0 0 0 1;];

R=Rx*Ry*Rz;

x=0;
y=0;
z=0;

X=[x y z 1];

XX=X*T*R
XX=X*R*T
XX=R*T*X
