%��������������������һ������ΪM�о���N�����ڵ㣩�о��󣬵ڶ�������Ϊ��������
%��Ϊ����װkarnaugh map�����Ļ���
%����ֵΪ��λ�Ķ�����ֵ

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