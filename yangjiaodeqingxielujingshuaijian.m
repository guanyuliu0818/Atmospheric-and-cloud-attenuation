
%% 5°到90°之间的仰角的倾斜路径衰减
% 若仰角在0-5°之间，用逐线计算法计算
% theta -- 单位：°（角度制）


tezhengshuaijian;
dengxiaogaodu;
Ao = ho*gamma_o;
Aw = hw*gamma_w;

A = (Ao+Aw)/sin(theta*pi/180);
disp("干燥空气衰减值 Ao： "+num2str(Ao)+" dB");
disp("湿空气衰减值 Aw： "+num2str(Aw)+" dB");
disp("总路径衰减值 A： "+num2str(A)+" dB");