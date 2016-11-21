%测试代码
%用啥考啥

function estimated_location=Ktest(Node_number,m_d_error,measure_data_probability,Microphone_1_Location_with_error,Microphone_2_Location_with_error,Size_Grid,scale)

%最开始的开始，判断以前是不是做过这个数量节点的定位
% fnamex=['Binsx',num2str(Node_number),'.mat'];
% fnamey=['Binsy',num2str(Node_number),'.mat'];
tag(1:Node_number)='#';
%%if((exist(fnamex,'file')==0)||(exist(fnamey,'file')==0))


%初始化会极大提升赋值效率
table_binary = zeros(2^Node_number,Node_number+2);
tt=zeros(2^Node_number,Node_number);
A=zeros(2^Node_number,2);
for i=0:(2^Node_number-1)
    %获取二进制的序列信息，递增的那种
    t=bitget(i,Node_number:-1:1);
    estimated_location_tt=GM_Probility_Cutting(Node_number,t,measure_data_probability,Microphone_1_Location_with_error,Microphone_2_Location_with_error,Size_Grid,scale);
    tt(i+1,1:Node_number)=t;
    A(i+1,1:2)=estimated_location_tt;
    %在这里必须优化A和tt的生成速度，循环赋值一定会卡住
end
A;
tt;
table_binary(1:2^Node_number,1:Node_number)=tt;
table_binary(1:2^Node_number,Node_number+1:Node_number+2)=A;



table_binary;

%到这里得到了全表以及对应的全部位置信息。 
%下一步？应该获取公式了


%取出x和y，计算table_binary大小
[tb1,tb2]=size(table_binary);
table_x=table_binary(1:tb1,tb2-1);
table_y=table_binary(1:tb1,tb2);
%相当于把A的两列单独拿了出来

 
%把十进制的坐标转换为二进制
table_x_bin=dec2bin(table_x*10000);
table_y_bin=dec2bin(table_y*10000);
%这里进行的是列操作，按照这里的惯例，是17列

%计算二进制长度,x和y是一样的
x_bin_length=length(table_x_bin(1,:));%暂时不用
y_bin_length=length(table_y_bin(1,:));%暂时不用

%保持一致，x不比y短，以后用x运算
if x_bin_length<y_bin_length
    x_bin_length=y_bin_length;
end

%……………………………………………………
%到这里获取到了位置的二进制信息。
%……………………………………………………

%告诉我Bins是怎么把二进制信息剥离的。
%Bins可以分列获取节点数目的信息啊，然后就做成了公式
%不用minTruthtable，只用table_x_bin



%Binxj-分块变量
%Binx-区分不同位变量
%Binsx-保存全部位全部公式变量，最后写文件也是它
%我那4个节点拓展为7个节点作为例子
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

    
    
    %现在算法的时间复杂度瓶颈就在于这个算法了，9个节点需要近1分钟才能跑出来。
    %如何避免每次都要算，把Bins变成可以存取的数据呢
    %一个可行的方法是存储到文件里，动态的文件名，节点数作为参数来命名
    %取得时候按照节点数分别取像查字典一样
    if(isempty(Binsx))
        Binsx=Binx;
        continue;
    end
    Binsx=[Binsx;tag;Binx];
    Binx=[];
    
end

%x和y的索引长度果然还是有区别的
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
    
    %同x
    if(isempty(Binsy))
        Binsy=Biny;
        continue;
    end
    Binsy=[Binsy;tag;Biny];
    Biny=[];
end
    Binsx=[Binsx;tag];
    Binsy=[Binsy;tag];
    %以上是公式的制作过程，x和y是没有明显逻辑区别的
    
    %下面试图存储
%     %把文件名挪到最上面了
%     save(fnamex,'Binsx')
%     save(fnamey,'Binsy')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end         %correspond to the first if
%     load(fnamex);
%     load(fnamey);
    %这是正确的读取文件方法
    %如果没有bug，那么已经实现了离线制作公式的步骤
    
%可以说，Bins公式集合已经做好了
%加入y一会，就叫Binsx了
%公式集合也被暂时存储了
%给一个串儿，如何还原回原来的二进制信息呢
%做一个循环，里面有小的Bin，和Bins的建立过程刚好相反



%查公式的代码块
%这个块儿实现了一次查询，利用现成的公式
%如何把公式离线化
for i=1:Node_number
    m_d(i)=num2str(m_d_error(i,1));
end
%先准备一下待查序列，变成字符串类型的

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

%到这里，查公式的工作也完成了
%返回值可以很轻松的通过除以10000完成
%下面的玩意还有没有用完全取决于即将进行的测试

%告诉我tBinx和tBiny是啥。
%它们是字典。

estimated_location=[x/10000 y/10000];

%2个方向16如分两块15
%15入拓展成16块

        
