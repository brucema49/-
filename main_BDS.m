%���ļ�
BDS=fopen('E:\����\���ǵ�����λ\src\2\MATLABԴ����\brdc0010.txt','r');
%�ж��ļ��Ƿ��ȡ�ɹ�
if BDS<0
    error('�ļ���ȡʧ�ܡ�');
end
%�ļ�����
line=0;
%Ԥ�����ڴ�
Xk=zeros(200,1);
Yk=zeros(200,1);
Zk=zeros(200,1);
xk=zeros(200,1);
yk=zeros(200,1);
position=zeros(200,3);%λ�þ���
%�������࣬����ĩ��...��ʾ������һ��
satellite=struct('PRN','Year','Month','Day','Hour','Minute',...
    'Second','ClockBias','ClockDirft','ClockDirftRate','IodeIssueofData',...
    'Crs','Delta_n','M0','Cuc','e','Cus' ,'sqrt_A',...
    'toe','Cic','OMEGA','Cis','i0','Crc','omega', 'OMEGADOT','IDOT',...
    'CodesOnL2Channel','GPSWeek','L2_p_data_flag','SV_accuracy','SV_health',...
'TGD','IODC_Issue_of_Data','Transmission_time_of_message','Fit_interval');
satellite=repmat(satellite,[1000 40]);
%��ȡ�ļ�ͷ
IonAlpha=zeros(4,1);
IonBeta=zeros(4,1);
str='';
while ~contains(str,'END OF HEADER') %��ȡ��END OF HEADER�����ļ�ͷ��ȡ
    str=fgetl(BDS);
    line=line+1;
    if contains(str,'RINEX VERSION / TYPE')
        type=str2double(str(6:9));
    end
    
    if contains(str,'ION ALPHA')
        str=strrep(str,'D','e');  %��D�滻Ϊe
        IonAlpha(1)=str2double(str(5:14));
        IonAlpha(2)=str2double(str(17:26));
        IonAlpha(3)=str2double(str(28:38));
        IonAlpha(4)=str2double(str(40:50));
    end
    
    if contains(str,'ION BETA')
        str=strrep(str,'D','e');
        IonBeta(1)=str2double(str(5:15));
        IonBeta(2)=str2double(str(17:27));
        IonBeta(3)=str2double(str(28:39));
        IonBeta(4)=str2double(str(40:51));
    end
end


%��ȡ����
i=1;%��������
g=1;m=1;tk=zeros(200,1);
Mx=zeros(200,1);My=zeros(200,1);Mz=zeros(200,1);
Gx=zeros(50,1);Gy=zeros(50,1);Gz=zeros(50,1);
while ~feof(BDS)
    str=fgetl(BDS);
    str=strrep(str,'D','e');
    line=line+1;
    %ֱ��ʹ�ö�̬�ṹ��satellite    
        if mod(line,8)==1
        satellite(i).PRN=str2double(strrep(str(1:2),' ',''));
        satellite(i).Year=str2double(str(4:5));
        satellite(i).Month=str2double(str(7:8));
        satellite(i).Day=str2double(str(10:11));
        satellite(i).Hour=str2double(str(13:14));
        satellite(i).Minute=str2double(str(16:17));
        satellite(i).Second=str2double(strrep(str(19:22),' ',''));
        satellite(i).ClockBias=str2double(strrep(str(23:41),' ',''));
        satellite(i).ClockDirft=str2double(strrep(str(42:60),' ',''));
        satellite(i).ClockDirftRate=str2double(strrep(str(61:79),' ',''));
        end
    if mod(line,8)==2
        satellite(i).IodeIssueofData=str2double(strrep(str(4:22),' ',''));
        satellite(i).Crs=str2double(strrep(str(23:41),' ',''));
        satellite(i).Delta_n=str2double(strrep(str(42:60),' ',''));
        satellite(i).M0=str2double(strrep(str(61:79),' ',''));
    end
    if mod(line,8)==3
        satellite(i).Cuc=str2double(strrep(str(4:22),' ',''));
        satellite(i).e=str2double(strrep(str(23:41),' ',''));
        satellite(i).Cus=str2double(strrep(str(42:60),' ',''));
        satellite(i).sqrt_A=str2double(strrep(str(61:79),' ',''));
    end
    if mod(line,8)==4
        satellite(i).toe=str2double(strrep(str(4:22),' ',''));
        satellite(i).Cic=str2double(strrep(str(23:41),' ',''));
        satellite(i).OMEGA=str2double(strrep(str(42:60),' ',''));
        satellite(i).Cis=str2double(strrep(str(61:79),' ',''));
    end
    if mod(line,8)==5
        satellite(i).i0=str2double(strrep(str(4:22),' ',''));
        satellite(i).Crc=str2double(strrep(str(23:41),' ',''));
        satellite(i).omega=str2double(strrep(str(42:60),' ',''));
        satellite(i).OMEGADOT=str2double(strrep(str(61:79),' ',''));
    end
    if mod(line,8)==6
        satellite(i).IDOT=str2double(strrep(str(4:22),' ',''));
        satellite(i).CodesOnL2Channel=str2double(strrep(str(23:41),' ',''));
        satellite(i).GPSWeek=str2double(strrep(str(42:60),' ',''));
        satellite(i).L2_p_data_flag=str2double(strrep(str(61:79),' ',''));
    end
    if mod(line,8)==7
        satellite(i).SV_accuracy=str2double(strrep(str(4:22),' ',''));
        satellite(i).SV_health=str2double(strrep(str(23:41),' ',''));
        satellite(i).TGD=str2double(strrep(str(42:60),' ',''));
        satellite(i).IODC_Issue_of_Data=str2double(strrep(str(61:79),' ',''));
    end
    if mod(line,8)==0
        satellite(i).Transmission_time_of_message=str2double(strrep(str(4:22),' ',''));
        satellite(i).Fit_interval=str2double(strrep(str(23:41),' ',''));
      %һ�����ݿ��Ѷ���,����PRN�����ǹ���㷨����
      
           if satellite(i).PRN==1||satellite(i).PRN==2||satellite(i).PRN==3||satellite(i).PRN==4||satellite(i).PRN==5||satellite(i).PRN==59||...
               satellite(i).PRN==60||satellite(i).PRN==61
               
             [Xk(i),Yk(i),Zk(i),xk(i),yk(i),tk(i)]=GEO( satellite(i).Year,satellite(i).Month,satellite(i).Day,satellite(i).Hour,satellite(i).Minute ,...
                 satellite(i).Second,satellite(i).ClockBias,satellite(i).ClockDirft,satellite(i).ClockDirftRate, ...
                     satellite(i).IodeIssueofData,satellite(i).Crs ,      satellite(i).Delta_n,   satellite(i).M0, ...
                     satellite(i).Cuc,            satellite(i).e,         satellite(i).Cus,       satellite(i).sqrt_A, ...
                     satellite(i).toe,            satellite(i).Cic,       satellite(i).OMEGA,     satellite(i).Cis, ...
                     satellite(i).i0, satellite(i).Crc,  satellite(i).omega,satellite(i).OMEGADOT,satellite(i).IDOT);
                  %���Ƕ���ֻ��Ҫ����IDOT
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

 disp('λ�þ���Ϊ');
 disp(position);
%��������λ�ö�άͼ��
figure;scatter(xk, yk, 10);xlabel('x'),ylabel('y');

%��������λ����άͼ��
figure;
scatter3(Gx,Gy,Gz,15);
hold on
scatter3(Mx,My,Mz,5,'g');
xlabel('x'),ylabel('y'),zlabel('z');


