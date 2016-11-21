%�������������ļ�uX.m�����ļ��ṩ���빫ʽ����
%best regards

function estimated_location=Karnaugh_Map_Prediction(table_binary,node_seq)
%�ȶ�table_binary���������ظ���ȥ����xyȡƽ��
%matlab�ṩ��unique��ismember���������������õ���
[tb1,tb2]=size(table_binary);
table_bin=table_binary(1:tb1,1:tb2-2);
         
table_bin;
table_bin_uni=unique(table_bin,'rows');

[sx,sy]=size(table_bin_uni);

%���ѭ��
tploc=[];
         
for j=1:sx
a=table_bin_uni(j,:);          
%�ⲿ�����ڲ�ѭ��������table_bin�Ի���ظ����ݵ�λ��
location=[];
for i=1:100
    b=table_bin(i:100,:);
    [~,loca]=ismember(a,b,'rows');
    if loca==1
        location=[location i];
    end
end
location;
[lx,ly]=size(location);
%��ȡtable_binary���xyֵ
txy=[];
for i=1:ly
    m=location(lx,i);
    %m����t_by�������
    txy=[txy ;table_binary(m,tb2-1:tb2)];
end
x=mean(txy(:,1));
y=mean(txy(:,2));
s=[x,y];
tploc=[tploc;s];
end
tploc;
%����Ϊtable_binary��ֵ
table_binary=[table_bin_uni tploc];

%ȡ��x��y������table_binary��С
[tb1,tb2]=size(table_binary);
table_x=table_binary(1:tb1,tb2-1);
table_y=table_binary(1:tb1,tb2);


%��ʮ���Ƶ�����ת��Ϊ������
table_x_bin=dec2bin(table_x*10000);
table_y_bin=dec2bin(table_y*10000);

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
    %if x_bin(i)==0
    %    temp_seqx;
    %end
end

%����ת��Ϊ�ַ���
sx=num2str(x_bin);
sy=num2str(y_bin);

%�ַ����������ƣ�ת��Ϊʮ����
x=bin2dec(sx);
y=bin2dec(sy);
estimated_location=[x/10000 y/10000];

        
