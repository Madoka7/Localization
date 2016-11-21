%本函数共两个参数，第一个参数为M行矩阵N（个节点）列矩阵，第二个参数为待查序列
%作为被封装karnaugh map函数的基础
%返回值为该位的二进制值

function x=uXX(x3,o_chr)
x=0;
t=1;
chr=o_chr;
[M,N]=size(x3);
for i=1:M
    a=num2str(x3(i,:));
    b=num2str(o_chr);
    if a==b
        t=1;
    end
    x=x+t;
    chr=o_chr;
end
x
if x>1
    x=1;
end