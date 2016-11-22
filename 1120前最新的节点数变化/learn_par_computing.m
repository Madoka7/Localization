tic

%传统方式计算

c1=1;

for i = 1:500

   c1 = c1+max(eig(rand(i,i)));

end

t1 = toc;

parpool local 4;

%parfor并行方式计算

tic

c2=1;

parfor ii = 1:500

  c2 = c2+max(eig(rand(ii,ii)));

end

t2 = toc;

parpool close;

display(strcat('parfor并行计算时间：',num2str(t2),'秒'));

display(strcat('客户端串行计算时间：',num2str(t1),'秒'));