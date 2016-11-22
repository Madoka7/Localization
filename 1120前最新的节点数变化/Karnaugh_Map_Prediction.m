%���Դ���
%��ɶ��ɶ

function estimated_location=Ktest(Node_number,m_d_error,measure_data_probability,Microphone_1_Location_with_error,Microphone_2_Location_with_error,Size_Grid,scale)

%�ʼ�Ŀ�ʼ���ж���ǰ�ǲ���������������ڵ�Ķ�λ
% fnamex=['Binsx',num2str(Node_number),'.mat'];
% fnamey=['Binsy',num2str(Node_number),'.mat'];
tag(1:Node_number)='#';
%%if((exist(fnamex,'file')==0)||(exist(fnamey,'file')==0))


%��ʼ���Ἣ��������ֵЧ��
table_binary = zeros(2^Node_number,Node_number+2);
tt=zeros(2^Node_number,Node_number);
A=zeros(2^Node_number,2);
for i=0:(2^Node_number-1)
    %��ȡ�����Ƶ�������Ϣ������������
    t=bitget(i,Node_number:-1:1);
    estimated_location_tt=GM_Probility_Cutting(Node_number,t,measure_data_probability,Microphone_1_Location_with_error,Microphone_2_Location_with_error,Size_Grid,scale);
    tt(i+1,1:Node_number)=t;
    A(i+1,1:2)=estimated_location_tt;
    %����������Ż�A��tt�������ٶȣ�ѭ����ֵһ���Ῠס
end
A;
tt;
table_binary(1:2^Node_number,1:Node_number)=tt;
table_binary(1:2^Node_number,Node_number+1:Node_number+2)=A;



table_binary;

%������õ���ȫ���Լ���Ӧ��ȫ��λ����Ϣ�� 
%��һ����Ӧ�û�ȡ��ʽ��


%ȡ��x��y������table_binary��С
[tb1,tb2]=size(table_binary);
table_x=table_binary(1:tb1,tb2-1);
table_y=table_binary(1:tb1,tb2);
%�൱�ڰ�A�����е������˳���

 
%��ʮ���Ƶ�����ת��Ϊ������
table_x_bin=dec2bin(table_x*10000);
table_y_bin=dec2bin(table_y*10000);
%������е����в�������������Ĺ�������17��

%��������Ƴ���
x_bin_length=length(table_x_bin(1,:));
y_bin_length=length(table_y_bin(1,:));



%����������������������������������������
%�������ȡ����λ�õĶ�������Ϣ��
%����������������������������������������

%������Bins����ô�Ѷ�������Ϣ����ġ�
%Bins���Է��л�ȡ�ڵ���Ŀ����Ϣ����Ȼ��������˹�ʽ
%����minTruthtable��ֻ��table_x_bin



%Binxj-�ֿ����
%Binx-���ֲ�ͬλ����
%Binsx-����ȫ��λȫ����ʽ���������д�ļ�Ҳ����
%����4���ڵ���չΪ7���ڵ���Ϊ����
Binsx=[];
Binsy=[];
Binx=[];
Biny=[];
for i=1:x_bin_length
    testix=table_x_bin(:,i)';
    row_nums=length(testix);

    for j=1:row_nums
        if(testix(j)=='1')
            for x=1:Node_number
                certain_row(1,x)=num2str(tt(j,x));
            end
            Binx=[Binx;certain_row(1,:)];
        end
    end

    
    
    %�����㷨��ʱ�临�Ӷ�ƿ������������㷨�ˣ�9���ڵ���Ҫ��1���Ӳ����ܳ�����
    %��α���ÿ�ζ�Ҫ�㣬��Bins��ɿ��Դ�ȡ��������
    %һ�����еķ����Ǵ洢���ļ����̬���ļ������ڵ�����Ϊ����������
    %ȡ��ʱ���սڵ����ֱ�ȡ����ֵ�һ��
    if(isempty(Binsx))
        Binsx=Binx;
        Binx=[];
        continue;
    end
    Binsx=[Binsx;tag;Binx];
    Binx=[];
    
end

%x��y���������ȹ�Ȼ�����������
for i=1:y_bin_length
    testiy=table_y_bin(:,i)';
    row_nums=length(testiy);

    for j=1:row_nums
        if(testiy(j)=='1')
            for y=1:Node_number
                certain_row(1,y)=num2str(tt(j,y));
            end
            Biny=[Biny;certain_row(1,:)];
        end
    end
    
    %ͬx
    if(isempty(Binsy))
        Binsy=Biny;
        Biny=[];
        continue;
    end
    Binsy=[Binsy;tag;Biny];
    Biny=[];
end
    Binsx=[Binsx;tag];
    Binsy=[Binsy;tag];
    %�����ǹ�ʽ���������̣�x��y��û�������߼������
    
    %������ͼ�洢
%     %���ļ���Ų����������
%     save(fnamex,'Binsx')
%     save(fnamey,'Binsy')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end         %correspond to the first if
%     load(fnamex);
%     load(fnamey);
    %������ȷ�Ķ�ȡ�ļ�����
    %���û��bug����ô�Ѿ�ʵ��������������ʽ�Ĳ���
    
%����˵��Bins��ʽ�����Ѿ�������
%����yһ�ᣬ�ͽ�Binsx��
%��ʽ����Ҳ����ʱ�洢��
%��һ����������λ�ԭ��ԭ���Ķ�������Ϣ��
%��һ��ѭ����������С��Bin����Bins�Ľ������̸պ��෴



%�鹫ʽ�Ĵ����
%������ʵ����һ�β�ѯ�������ֳɵĹ�ʽ
%��ΰѹ�ʽ���߻�
for i=1:Node_number
    m_d(i)=num2str(m_d_error(i,1));
end
%��׼��һ�´������У�����ַ������͵�

sBrx=length(Binsx(:,1));
sBry=length(Binsy(:,1));
tBinx=[];
tBiny=[];
ans_x=[];
ans_y=[];
count=0;
for i=1:sBrx
    if(strcmp(Binsx(i,:),tag))
        ans_x=[ans_x,uX(tBinx,m_d)];
        tBinx=[];
        continue;
    end
    tBinx=[tBinx;Binsx(i,:)];
end
for i=1:sBry
    if(strcmp(Binsy(i,:),tag))
        ans_y=[ans_y,uX(tBiny,m_d)];
        tBiny=[];
        continue;
    end
    tBiny=[tBiny;Binsy(i,:)];
end
ansx=num2str(ans_x);
ansy=num2str(ans_y);
x=bin2dec(ansx);
y=bin2dec(ansy);
count;

%������鹫ʽ�Ĺ���Ҳ�����
%����ֵ���Ժ����ɵ�ͨ������10000���
%��������⻹��û������ȫȡ���ڼ������еĲ���

%������tBinx��tBiny��ɶ��
%�������ֵ䡣

estimated_location=[x/10000 y/10000];



%161122 11:29
%����8->112768������
%����Ϊ��
%8��      10011100010000000
%11.2768��11011100010000000
%���Ƶģ�95000��127768Ҳ�����
%95000�� 10111001100011000
%127768��11111001100011000
%���Կ������ڶ���λ��������ֵ���ԭ����ʲô��
%��һ��λ��2��16�η�
%�ڶ���λ��2��15�η�
%����Ϊ��ת�����Դ������������⣬��Ϊ��minTruthtable�汾��û������bug
%�����Ͼ��ǲ����������߼�Ӧ��û����ȻΪʲôֻ��ڶ�λ��
%65536֮��ͻ����������⣬Ϊʲô��
%�������ǲ��ǵ�һ��ѭ����ȷ�����λ��������ѭ��������
%��ô���������ô֪�����ﲻ�ԣ�
%һ��һ������num2str�϶�û����
%Ҫô�Ǳ��������Ҫô�Ǳ�Ĳ�ѯ��Ŀǰ���������Ĳ��ִ�һ�㡣
%�ҵ������ˣ��ڶ���λ�ı����������˵�һ��λ������
%���Ե�һ��λ��1��ʱ��ڶ���λҲ�����1
%ԭ����BinsxΪ�յ�ʱ��û�а�Binx��Biny���
%����ˣ�12��37
