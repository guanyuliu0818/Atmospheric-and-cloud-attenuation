%% 等效高度的计算
% 适用于10km高度内
% INPUT
%	ilat= latitude index,    range (1..121) 1=90 2=88.5 121=-90 [deg] 
%   ilong = longitude index, range=(1..240) 1=0 2=1.5 240=358.5 [deg]
% 	N.B. 
%       ilat = ilong = -1 : close the input files

% p_tot 总空气压力---单位为hPa
% t 温度---单位为℃
% f 频率---单位为GHz
% RESYLT:gamma_o --干燥空气的大气衰减(dB/km)
% ilat = 32; ilon = 118，为南京的经纬度
% month = 2; （范围：1-12，对应月份）
% time = 2 （time =1, 2, 3, 4依次对应00, 06, 12, 18 UTC，即北京时间08, 14, 20. 02时）
ilatn = roundn((91.5-ilat)/1.5, 0);
ilongn = roundn(ilon/1.5+1,0);
[tk,pr,vd,hm]=read_mprof(ilatn,ilongn);
if month == 0 && time == 0
    p_tot = squeeze(mean(mean(pr(:,:,lev),1),2));
    t = squeeze(mean(mean(tk(:,:,lev),1),2))-273.15; %℃和K单位转换
    rou = squeeze(mean(mean(vd(:,:,lev),1),2));
elseif month == 0
    p_tot = squeeze(mean(pr(:,time,lev),1));
    t  =  squeeze(mean(tk(:,time,lev),1))-273.15;
    rou = squeeze(mean(vd(:,time,lev),1));
elseif time ==0
    p_tot = squeeze(mean(pr(month,:,lev),2));
    t  =  squeeze(mean(tk(month,:,lev),2))-273.15;
    rou = squeeze(mean(vd(month,:,lev),2));
else
    p_tot = pr(month,time,lev);
    t = tk(month,time,lev)-273.15; %℃和K单位转换
    rou = vd(month,time,lev);
end


r_p = p_tot/1013;
r_t = 288/(233+t);

% 计算过程
% 干燥空气
t1 = 4.64/(1+0.066*r_p^(-2.3))*exp(-((f-59.7)/(2.87+12.4*exp(-7.9*r_p)))^2);
t2 = 0.14*exp(2.12*r_p)/((f-118.75)^2+0.031*exp(2.2*r_p));
t3 = 0.0114/(1+0.14*r_p^(-2.6))*f*(-0.0247+0.0001*f+1.16*10^-6*f^2)/(1-0.0169*f+4.1*10^-5*f^2+3.2*10^-7*f^3);
ho = 6.1/(1+0.17*r_p^(-1.1))*(1+t1+t2+t3);
% 水汽
sigma_w = 1.013/(1+exp(-8.6*(r_p-0.57)));
hw = 1.66*(1+1.39*sigma_w/((f-22.235)^2+2.56*sigma_w)+3.37*sigma_w/((f-183.31)^2+4.69*sigma_w)+1.58*sigma_w/((f-325.1)^2+2.89*sigma_w));

disp("干空气等效高度ho = "+num2str(ho)+" km");
disp("湿空气等效高度ho = "+num2str(hw)+" km");

