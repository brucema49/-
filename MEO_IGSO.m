function [Xk,Yk,Zk,xk,yk,tk] = MEO_IGSO(year,month,day,hour,minute,second,a0,a1,a2,IodeIssueofData,Crs,deta_n,M0,Cuc,...
e,Cus,a_sqrt,t0e,Cic,W0,Cis,i0,Crc,w,W_,I_)
%1.计算卫星运行的平均角速度n
u=3.986004418*10^14;
n0=sqrt(u)/(a_sqrt)^3;
n=n0+deta_n;
%2.计算归化时间tk

s1=floor((1461*(year+4800+ floor((month-14)/12 )))/4 );
s2= floor(367*(month-2-floor((month-14)/12 )*12)/12 );
s3=floor(3*floor((year+4900+floor((month-14)/12) )/100)/4 );
jd=day-32075+s1+s2-s3-0.5+hour/24+minute/1440+second/86400;
z=floor((jd-2453736.5)/7);
t_=((jd-2453736.5)/7-z)*604800;
t0c=t_;
deta_t=a0+a1*(t_-t0c)+a2*(t_-t0c);
t=t_-deta_t;
tk=t-t0e;

%3.观测时刻卫星平近点角Mk的计算
Mk=M0+n*tk;

%4.计算偏近点角Ek
E=1;
Ek=Mk;
while E>10^(-6)
    E=Ek;
   Ek=Mk+e*sin(Ek); 
   E=abs(Ek-E);
end;
   
   
%5.真近点角Vk的计算
 Vk=atan((sqrt(1-e*e)*sin(Ek))/(cos(Ek)-e));
 
%6.升交距角Fk的计算
Fk=Vk+w;


%7.摄动改正项su,sr,si的计算
su=Cuc*cos(2*Fk)+Cus*sin(2*Fk);
sr=Crc*cos(2*Fk)+Crs*sin(2*Fk);
si=Cic*cos(2*Fk)+Cis*sin(2*Fk);


%8.计算经过改正的升交距角uk、卫星矢径rk和轨道倾角ik
uk=Fk+su;
rk=a_sqrt*a_sqrt*(1-e*cos(Ek))+sr;
ik=i0+si+I_*tk;
%9.计算卫星在轨道平面直角坐标系的坐标
xk=rk*cos(uk);
yk=rk*sin(uk);

%10计算观测时刻升交点经度Wk
we=7.292115*10^(-5);
Wk=W0+(W_-we)*tk-we*t0e;

%11
Xk=xk*cos(Wk)-yk*cos(ik)*sin(Wk);
Yk=xk*sin(Wk)+yk*cos(ik)*cos(Wk);
Zk=yk*sin(ik);
