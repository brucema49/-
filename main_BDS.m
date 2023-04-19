%打开文件
BDS=fopen('E:\桌面\卫星导航定位\src\2\MATLAB源程序\brdc0010.txt','r');
%判断文件是否读取成功
if BDS<0
    error('文件读取失败。');
end
%文件行数
line=0;
%预分配内存
Xk=zeros(200,1);
Yk=zeros(200,1);
Zk=zeros(200,1);
xk=zeros(200,1);
yk=zeros(200,1);
position=zeros(200,3);%位置矩阵
%参数过多，在行末以...表示连接下一行
satellite=struct('PRN','Year','Month','Day','Hour','Minute',...
    'Second','ClockBias','ClockDirft','ClockDirftRate','IodeIssueofData',...
    'Crs','Delta_n','M0','Cuc','e','Cus' ,'sqrt_A',...
    'toe','Cic','OMEGA','Cis','i0','Crc','omega', 'OMEGADOT','IDOT',...
    'CodesOnL2Channel','GPSWeek','L2_p_data_flag','SV_accuracy','SV_health',...
'TGD','IODC_Issue_of_Data','Transmission_time_of_message','Fit_interval');
satellite=repmat(satellite,[1000 40]);


%读取数据
i=1;%卫星数量
g=1;m=1;tk=zeros(200,1);
Mx=zeros(200,1);My=zeros(200,1);Mz=zeros(200,1);
Gx=zeros(50,1);Gy=zeros(50,1);Gz=zeros(50,1);
while ~feof(BDS)
    str=fgetl(BDS);
    str=strrep(str,'D','e');
    line=line+1;
    %直接使用动态结构体satellite    
        if mod(line,8)==1
        satellite(i).PRN=str2double(str(2:3));
        satellite(i).Year=str2double(str(5:8));
        satellite(i).Month=str2double(str(10:11));
        satellite(i).Day=str2double(str(13:14));
        satellite(i).Hour=str2double(str(16:17));
        satellite(i).Minute=str2double(str(19:20));
        satellite(i).Second=str2double(strrep(str(22:23),' ',''));
        satellite(i).ClockBias=str2double(strrep(str(24:42),' ',''));
        satellite(i).ClockDirft=str2double(strrep(str(43:61),' ',''));
        satellite(i).ClockDirftRate=str2double(strrep(str(62:80),' ',''));
        end
    if mod(line,8)==2
        satellite(i).IodeIssueofData=str2double(strrep(str(5:23),' ',''));
        satellite(i).Crs=str2double(strrep(str(24:42),' ',''));
        satellite(i).Delta_n=str2double(strrep(str(43:61),' ',''));
        satellite(i).M0=str2double(strrep(str(62:80),' ',''));
    end
    if mod(line,8)==3
        satellite(i).Cuc=str2double(strrep(str(5:23),' ',''));
        satellite(i).e=str2double(strrep(str(24:42),' ',''));
        satellite(i).Cus=str2double(strrep(str(43:61),' ',''));
        satellite(i).sqrt_A=str2double(strrep(str(62:80),' ',''));
    end
    if mod(line,8)==4
        satellite(i).toe=str2double(strrep(str(5:23),' ',''));
        satellite(i).Cic=str2double(strrep(str(24:42),' ',''));
        satellite(i).OMEGA=str2double(strrep(str(43:61),' ',''));
        satellite(i).Cis=str2double(strrep(str(62:80),' ',''));
    end
    if mod(line,8)==5
        satellite(i).i0=str2double(strrep(str(5:23),' ',''));
        satellite(i).Crc=str2double(strrep(str(24:42),' ',''));
        satellite(i).omega=str2double(strrep(str(43:61),' ',''));
        satellite(i).OMEGADOT=str2double(strrep(str(62:80),' ',''));
    end
    if mod(line,8)==6
        satellite(i).IDOT=str2double(strrep(str(5:23),' ',''));
        satellite(i).CodesOnL2Channel=str2double(strrep(str(24:42),' ',''));
        satellite(i).GPSWeek=str2double(strrep(str(43:61),' ',''));
        satellite(i).L2_p_data_flag=str2double(strrep(str(62:80),' ',''));
    end
    if mod(line,8)==7
        satellite(i).SV_accuracy=str2double(strrep(str(5:23),' ',''));
        satellite(i).SV_health=str2double(strrep(str(24:42),' ',''));
        satellite(i).TGD=str2double(strrep(str(43:61),' ',''));
        satellite(i).IODC_Issue_of_Data=str2double(strrep(str(62:80),' ',''));
    end
    if mod(line,8)==0
        satellite(i).Transmission_time_of_message=str2double(strrep(str(5:23),' ',''));
        satellite(i).Fit_interval=str2double(strrep(str(24:42),' ',''));
      %一个数据块已读完,依据PRN对卫星轨道算法分类
      
           if satellite(i).PRN==1||satellite(i).PRN==2||satellite(i).PRN==3||satellite(i).PRN==4||satellite(i).PRN==5||satellite(i).PRN==59||...
               satellite(i).PRN==60||satellite(i).PRN==61
               
             [Xk(i),Yk(i),Zk(i),xk(i),yk(i),tk(i),sr(i)]=GEO( satellite(i).Year,satellite(i).Month,satellite(i).Day,satellite(i).Hour,satellite(i).Minute ,...
                 satellite(i).Second,satellite(i).ClockBias,satellite(i).ClockDirft,satellite(i).ClockDirftRate, ...
                     satellite(i).IodeIssueofData,satellite(i).Crs ,      satellite(i).Delta_n,   satellite(i).M0, ...
                     satellite(i).Cuc,            satellite(i).e,         satellite(i).Cus,       satellite(i).sqrt_A, ...
                     satellite(i).toe,            satellite(i).Cic,       satellite(i).OMEGA,     satellite(i).Cis, ...
                     satellite(i).i0, satellite(i).Crc,  satellite(i).omega,satellite(i).OMEGADOT,satellite(i).IDOT);
                  %卫星定轨只需要传到IDOT
                  Gx(g,1)=Xk(i);Gy(g,1)=Yk(i);Gz(g,1)=Zk(i);g=g+1;           
           else
             [Xk(i),Yk(i),Zk(i),xk(i),yk(i),tk(i)]=MEO_IGSO(satellite(i).Year,satellite(i).Month,satellite(i).Day,satellite(i).Hour,satellite(i).Minute ,...
                     satellite(i).Second,satellite(i).ClockBias,satellite(i).ClockDirft,satellite(i).ClockDirftRate, ...
                     satellite(i).IodeIssueofData,satellite(i).Crs ,      satellite(i).Delta_n,   satellite(i).M0, ...
                     satellite(i).Cuc,            satellite(i).e,         satellite(i).Cus,       satellite(i).sqrt_A, ...
                     satellite(i).toe,            satellite(i).Cic,       satellite(i).OMEGA,     satellite(i).Cis, ...               
                     satellite(i).i0, satellite(i).Crc,  satellite(i).omega,satellite(i).OMEGADOT,satellite(i).IDOT); 
                 Mx(m,1)=Xk(i);My(m,1)=Yk(i);Mz(m,1)=Zk(i);m=m+1;
           end  
          
            position(i,1)=Xk(i);position(i,2)=Yk(i); position(i,3)=Zk(i);
          i=i+1;  
    end 
end

 disp('位置矩阵为');
 disp(position);
%绘制卫星位置二维图形
figure;scatter(xk, yk, 10);xlabel('x'),ylabel('y');

%绘制卫星位置三维图形
figure;
scatter3(Gx,Gy,Gz,15);
hold on
scatter3(Mx,My,Mz,5,'g');
xlabel('x'),ylabel('y'),zlabel('z');
[x,y,z]=sphere(50)
X=x*6371.393*10^3;
Y=y*6371.393*10^3;
Z=z*6371.393*10^3;
surf(X,Y,Z)

