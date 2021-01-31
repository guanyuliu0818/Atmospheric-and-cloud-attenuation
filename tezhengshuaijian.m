%% 特征衰减

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
% 干燥空气的大气衰减 dB/km
kesai1 = phi(r_p,r_t,0.0717,-1.8132,0.0156,-1.6515);
kesai2 = phi(r_p,r_t,0.5146,-4.6368,-0.1921,-5.7416);
kesai3 = phi(r_p,r_t,0.3414,-6.5851,0.2130,-8.5854);
kesai4 = phi(r_p,r_t,-0.0112,0.0092,-0.1033,-0.0009);
kesai5 = phi(r_p,r_t,0.2705,-2.7192,-0.3016,-4.1033);
kesai6 = phi(r_p,r_t,0.2445,-5.9191,0.0422,-8.0719);
kesai7 = phi(r_p,r_t,-0.1833,6.5589,-0.2402,6.131);
gamma54 = 2.192*phi(r_p,r_t, 1.8286, -1.9487, 0.4051, -2.8509);
gamma58 = 12.59*phi(r_p,r_t, 1.0045, 3.5610, 0.1588, 1.2834);
gamma60 = 15.0*phi(r_p,r_t,0.9003,4.1335,0.0427,1.6088);
gamma62 = 14.28*phi(r_p,r_t,0.9886,3.4176,0.1827,1.3429);
gamma64 = 6.819*phi(r_p,r_t,1.4320,0.6258,0.3177,-0.5914);
gamma66 = 1.908*phi(r_p,r_t,2.0717,-4.1404,0.4910,-4.8718);
delta = -0.00306*phi(r_p,r_t,3.211,-14.94,1.583,-16.37);
if f<=54
    gamma_o = (7.2*r_t^2.8/(f^2+0.34*r_p^2*r_t^1.6)+0.62*kesai3/((54-f)^(1.16*kesai1)+0.83*kesai2))*f^2*r_p^2*10^-3;
elseif f<=60
    gamma_o = exp(log(gamma54)/24*(f-58)*(f-60)-log(gamma58)/8*(f-54)*(f-60)+log(gamma60)/12*(f-54)*(f-58));
elseif f<=62
    gamma_o = gamma60+(gamma62-gamma60)*(f-60)/2;
elseif f<=66
    gamma_o = exp(log(gamma62)/8*(f-64)*(f-66)-log(gamma64)/4*(f-62)*(f-66)+log(gamma66)/8*(f-62)*(f-64));
elseif f<=120
    gamma_o = (3.02*10^-4*r_t^3.5+0.283*r_t^3.8/((f-118.75)^2+2.91*r_p^2+r_t^1.6)+0.502*kesai6*(1-0.0163*kesai7*(f-66))/((f-66)^(1.4346*kesai4)+1.15*kesai5))*f^2*r_p^2*10^-3;
elseif f<=350
    gamma_o = (3.02*10^-4/(1+1.9*10^-5*f^1.5)+0.283*r_t^0.3/((f-118.75)^2+2.91*r_p^2*r_t^1.6))*f^2*r_p^2*r_t^3.5*10^-3+delta;
else
disp("干空气衰减率计算错误");
end
try
disp("干空气衰减率γo = "+num2str(gamma_o)+" dB/km");
catch
    disp("请输入≤350 Ghz的频率")
end

% 水汽中的衰减 dB/km
% rou ---水汽密度，g/m^3 
% 可从给ITU-R P.836-5的数字地图形式中查获
% RESYLT:gamma_w --水汽中的衰减(dB/km)

ita1 = 0.955*r_p*r_t^0.68+0.006*rou;
ita2 = 0.735*r_p*r_t^0.5+0.0353*r_t^4*rou;
gamma_w = (3.98*ita1*exp(2.23*(1-r_t))/((f-22.235)^2+9.42*ita1^2)*g(f,22)+11.96*ita1*exp(0.7*(1-r_t))/((f-183.31)^2+11.14*ita1^2)+0.081*ita1*exp(6.44*(1-r_t))/((f-321.226)^2+6.29*ita1^2)+3.66*ita1*exp(1.6*(1-r_t))/((f-325.153)^2+9.22*ita1^2)+25.37*ita1*exp(1.09*(1-r_t))/((f-380)^2)+17.4*ita1*exp(1.46*(1-r_t))/((f-448)^2)+844.6*ita1*exp(0.17*(1-r_t))/(f-557)^2*g(f,557)+290*ita1*exp(0.41*(1-r_t))/(f-752)^2*g(f,572)+8.3328*10^-4*ita2*exp(0.99*(1-r_t))/(f-1780)^2*g(f,1780))*f^2*r_t^2.5*rou*10^-4;
disp("湿空气衰减率γw = "+num2str(gamma_w)+" dB/km");


% 
% % rou也可以由下式计算
% % H---相对湿度，单位：%
% % T ---温度，单位：K
% H = 50;
% T = t+273.15;
% EF_water = 1+10^-4*(7.2+p_tot*(0.0032+5.9*10^-7*t^2));
% EF_ice = 1+10^-4*(2.2+p_tot*(0.00382+6.4*10^-7*t^2));
% 
% % H2O，适用于-40--50℃
% EF = EF_water;
% es = EF*6.1121*exp((18.678-t/234.5)*t/(t+257.14));
% rou = 216.7*H*es/(100*T);
% 
% % ICE，适用于-80--0℃
% EF = EF_ice;
% es = EF*6.1115*exp((23.036-t/333.7)*t/(t+279.82));
% rou = 216.7*H*es/(100*T);



