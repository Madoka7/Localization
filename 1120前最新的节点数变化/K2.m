%�������������ļ�uX.m�����ļ��ṩ���빫ʽ����
%best regards

%20160827  ��Ϊkyzs�ı�ְ����   ���Ʊ�����ܾ����������
%����
%��ŵͼ���������ݰ���Ҫ���������GM�㷨�����԰�GM�㷨�Ĳ�������������
%Ȼ��Ҫ�������ȫ0��ȫ1�ı����������ɡ�
%���������ɣ�������
%���������ɣ����ɺ������ã������ɱ���
%��������������


% estimated_location_tt= GM_Probility_Cutting(Node_number,t,measure_data_probability,Microphone_1_Location_with_error,Microphone_2_Location_with_error,Size_Grid,scale);

%20160907  ���Ҫ�����ǽڵ�������չ
%��2���뷨��һ���Ǹ���minTruthtable���������ӿ��Խ��ܵĴ�����
%��һ���뷨�ǰ��ҵĴ�����ģ�����minTruthtable��������bins���������������¡�
%������˼��һ���ĸ�������
%�ͼ����Ƕȣ���Ȼ�Ǹ�ϲ���޸�minTruthtable����������������������ô˵�����м�������
%���ڶ��������������ʱ�临�ӶȾ���2��ָ������ĸ��Ӷ��ˡ�
%��Ϊ����minTruthtable��һ�����ѵ�����
%������minTruthtable�����ǰ�����0��1��Ӧ�Խڵ�����������⡣

%����minTruthtable��ע��
%��˵��Ϊint16�����ƣ�tt�ĳ��Ȳ��ܳ���2��15�η�
%�Ҿ����룬Ҫ�ǿ��Ըı�tt���������ͣ���ô�ǲ��ǾͿ��Ըı䳤��

function estimated_location=K2(Node_number,m_d_error,measure_data_probability,Microphone_1_Location_with_error,Microphone_2_Location_with_error,Size_Grid,scale)

%�ʼ�Ŀ�ʼ���ж���ǰ�ǲ���������������ڵ�Ķ�λ
fnamex=['Binsx',num2str(Node_number),'.mat'];
fnamey=['Binsy',num2str(Node_number),'.mat'];
tag(1:Node_number)='#';

%����һ�½ڵ�����
%��ֵΪnode_num



%%if((exist(fnamex,'file')==0)||(exist(fnamey,'file')==0))

%��0����ûִ�й���ȡ��ʽ��Ҫִ������Ĵ���
%����ֱ�Ӿ�ȥload�ˡ�
%�Ѿ��ɹ��㶨��ʽ�洢���ٴ�������
%�����ԣ���ȡ�ļ�����ʵ�ֶ�λ��õ����
%������Ҫ����y�Ķ�λ�ˣ��ղŵĶ���x��
%�ƺ����ÿ���̫�ֻ࣬�����������ظ�һ��Ϳ���
%����ǿ�ŵͼ�����Ķ�λ����Ҫ��
%Ԥ�����뺺��һ�µ�
%��ʹ�����߶�λ�Ļ�
%�ͺ�����һ����
%���ܺ�������Ҳ���ܱ�֤ÿ�ζ���λ��ȷ


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

%��������Ƴ���,x��y��һ����
x_bin_length=length(table_x_bin(1,:));%��ʱ����
y_bin_length=length(table_y_bin(1,:));%��ʱ����

%����һ�£�x����y�̣��Ժ���x����
if x_bin_length<y_bin_length
    x_bin_length=y_bin_length;
end

%����������������������������������������
%�������ȡ����λ�õĶ�������Ϣ��
%����������������������������������������

%����ø�ʲô�أ�������ʽ��
%��δ洢��
%��ʽ�������ĸ��������š�
%һ��ʼֻ��x������ʵ��
test1=table_x_bin(:,1)';
%��ΰ��ַ������ �� ������ ֱ�ӿ����á�

% % % % % test1;
% % % % % [Bins,~,~,~] = minTruthtable(test1);
% % % % % Bins
%���εĲ��Դ���

%��һ����ʽ�����
%������һ�����ʽ������ô��
%��ô������洢��ʽ
%�������ñ�Ƿ�����ʼ�ǲ���Ҫ���ָ���#����β��*
%��β����Ҫ��*

%��ΪҪ�����ݵ����������һ��ʼ��ֵ��ʱ���أ��Ͱ�
%��������ֵ��2��16�η���ֵ����
%����Ӧ�ð����ֽ���
%����Ӧ�á��š�
%��Ǳ��õ���ǰ����
Binsx=[];
Binsy=[];
for i=1:x_bin_length
    testix=table_x_bin(:,i)';
    %һ���Ҫ�������testix�ֿ����
    %�ּ����أ���2^(node_num-15)���
    %�������2��15�η���һ����Ҳ�ܲ�����
    %�Ҳ�֪�����н������
    %�ǣ�������Ƴ���һ��С�Ĳ����߼�
    [Binx,inps,Nums,testix] = minTruthtable(testix); 
    
    %�����㷨��ʱ�临�Ӷ�ƿ������������㷨�ˣ�9���ڵ���Ҫ��1���Ӳ����ܳ�����
    %��α���ÿ�ζ�Ҫ�㣬��Bins��ɿ��Դ�ȡ��������
    %һ�����еķ����Ǵ洢���ļ����̬���ļ������ڵ�����Ϊ����������
    %ȡ��ʱ���սڵ����ֱ�ȡ����ֵ�һ��
    if(isempty(Binsx))
        Binsx=Binx;
        continue;
    end
    Binsx=[Binsx;tag;Binx];
end
%x��y���������ȹ�Ȼ�����������
for i=1:y_bin_length
    testiy=table_y_bin(:,i)';
    [Biny,inps,Nums,testiy] = minTruthtable(testiy);
    %ͬx
    if(isempty(Binsy))
        Binsy=Biny;
        continue;
    end
    Binsy=[Binsy;tag;Biny];
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
m_d;
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
        
estimated_location=[x/10000 y/10000];

% %����װ�����Ƶ�����
% x_bin=[];
% y_bin=[];
% 
% %ѭ������ÿλ�����ƵĹ���ֵ
% for i=1:x_bin_length
%     temp_seqx=[];
%     temp_seqy=[];
%     tempx=table_x_bin(:,i);
%     tempy=table_y_bin(:,i);
%     for j=1:tb1  %����table_binary
%         if tempx(j)=='1'
%             temp_seqx=[temp_seqx;table_binary(j,1:tb2-2)];
%         end
%         if tempy(j)=='1'
%             temp_seqy=[temp_seqy;table_binary(j,1:tb2-2)];
%         end
%     end
%     %ֻ����Щ��1���н�����ϼ���
%     x_bin(i)=uX(temp_seqx,node_seq);
%     y_bin(i)=uX(temp_seqy,node_seq);
%     %if x_bin(i)==0
%     %    temp_seqx;
%     %end
% end
% 
% %����ת��Ϊ�ַ���
% sx=num2str(x_bin);
% sy=num2str(y_bin);
% 
% %�ַ����������ƣ�ת��Ϊʮ����
% x=bin2dec(sx);
% y=bin2dec(sy);
% estimated_location=[x/10000 y/10000];

        
