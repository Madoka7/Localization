
N = 20;
Num = 2^N;

A = zeros(2^10,10);
for i=0:(2^10-1)
    A=[A;bitget(i,10:-1:1)];
    
end

A(1,:)