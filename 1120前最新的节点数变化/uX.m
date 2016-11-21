%本函数共两个参数，第一个参数为M行矩阵N（个节点）列矩阵，第二个参数为待查序列
%作为被封装karnaugh map函数的基础
%返回值为该位的二进制值

%更新于2016.8.25
%当输入为字符串类型时
%进行与或操作必须先转换为数值类型
%否则将出现‘0’|0，结果是的情况
function x=uX(bins,ture_table)
x=0;
t=1;
t1=[];
t2=1;
[M,N]=size(bins);
for i=1:M
    for j=1:N
        if char(bins(i,j))=='0'  %相当于查阅公式的每一位，此处判断，如果该位取反
            if char(ture_table(1,j))=='1'  %则翻转被代入的值，1变0，
                t2=0;
                %'01'
            else
                t2=1;  %0变1
                %'10'
            end
        end
		if char(bins(i,j))=='1'
            t2=str2num(ture_table(j));%如果公式中该位没有取反
            %'1111111'
        end
        if char(bins(i,j))=='-'
			t2=1;        %如果公式不需要此项   是 C+C~,令他恒等于1
            %'---'
        end
        t=t&t2;
        %t1=[t1 t];
    end
    x=x|t;
    t=1;
end
%t1
%if x>1
%    x=1;
%end