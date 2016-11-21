%�������������ļ�uX.m�����ļ��ṩ���빫ʽ����
%best regards
function [x,y]=old_old_Karnaugh_Map_Prediction(table_binary,node_seq)
%ȡ��x��y������table_binary��С
[tb1,tb2]=size(table_binary);
table_x=table_binary(1:tb1,tb2-1);
table_y=table_binary(1:tb1,tb2);
%��ʮ���Ƶ�����ת��Ϊ������
table_x_bin=dec2bin(table_x);
table_y_bin=dec2bin(table_y);
%��������Ƴ���,x��y��һ����
x_bin_length=length(table_x_bin(1,:));%��ʱ����
y_bin_length=length(table_y_bin(1,:));%��ʱ����
%����һ�£�x����y�̣��Ժ���x����
if x_bin_length<y_bin_length
    x_bin_length=y_bin_length;
end
%����װ�����Ƶ�����
x_bin=[];
y_bin=[];
%ѭ������ÿλ�����ƵĹ���ֵ
for i=1:x_bin_length
    temp_seqx=[];
    temp_seqy=[];
    tempx=table_x_bin(:,i);
    tempy=table_y_bin(:,i);
    for j=1:tb1  %����table_binary
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
%����ת��Ϊ�ַ���
sx=num2str(x_bin);
sy=num2str(y_bin);
%�ַ����������ƣ�ת��Ϊʮ����
x=bin2dec(sx);
y=bin2dec(sy);

estimated_location=[x/10000 y/10000];
