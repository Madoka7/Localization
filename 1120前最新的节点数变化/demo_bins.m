True_table=[1 1 0 1 1 0 0 0 ]; %最小项  真值表

  %  tt = '0000100-1-1110-1'; % m(4,8,10,11,12,15) + d(7,9,14)

tt='0000'; %定义类型
for i=1:length(True_table)
tt(i)=int2str(True_table(i));
end

tt

t = [11011001];
a='101';
%tt='0001';
Bins=[];
[Bins,inps,Nums,tt] = minTruthtable(tt);
Bins
%char(a(2))
result = uX(Bins,a);
result