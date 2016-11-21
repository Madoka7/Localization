%本函数依赖于文件uX.m，该文件提供代入公式函数
%best regards
function [x,y]=old_old_Karnaugh_Map_Prediction(table_binary,node_seq)
%取出x和y，计算table_binary大小
[tb1,tb2]=size(table_binary);
table_x=table_binary(1:tb1,tb2-1);
table_y=table_binary(1:tb1,tb2);
%把十进制的坐标转换为二进制
table_x_bin=dec2bin(table_x);
table_y_bin=dec2bin(table_y);
%计算二进制长度,x和y是一样的
x_bin_length=length(table_x_bin(1,:));%暂时不用
y_bin_length=length(table_y_bin(1,:));%暂时不用
%保持一致，x不比y短，以后用x运算
if x_bin_length<y_bin_length
    x_bin_length=y_bin_length;
end
%申请装二进制的数组
x_bin=[];
y_bin=[];
%循环计算每位二进制的估计值
for i=1:x_bin_length
    temp_seqx=[];
    temp_seqy=[];
    tempx=table_x_bin(:,i);
    tempy=table_y_bin(:,i);
    for j=1:tb1  %遍历table_binary
        if tempx(j)=='1'
            temp_seqx=[temp_seqx;table_binary(j,1:tb2-2)];
        end
        if tempy(j)=='1'
            temp_seqy=[temp_seqy;table_binary(j,1:tb2-2)];
        end
    end
    x_bin(i)=uX(temp_seqx,node_seq);
    y_bin(i)=uX(temp_seqy,node_seq);
    temp_seqx=[];
    temp_seqy=[];
end
%数组转化为字符串
sx=num2str(x_bin);
sy=num2str(y_bin);
%字符串（二进制）转化为十进制
x=bin2dec(sx);
y=bin2dec(sy);

estimated_location=[x/10000 y/10000];
