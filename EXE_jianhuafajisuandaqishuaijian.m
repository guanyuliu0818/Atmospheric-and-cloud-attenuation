clear all; clc; close all;
%% 简化法计算大气衰减

f =  input("请输入频率（单位：GHz）, f<=350 GHz    ");


if f>350
    disp("推荐您用逐线计算法")
else
    month =  input("请输入月份（0--月平均，1--1月，2--2月 ... 12--12月)  ");
    time =  input("请输入时间（ 0--日平均，1-- 北京时间08时，2-- 北京时间14时，3--北京时间20时，4--北京时间02时） ");
    lev =  1;
    ilat =  input("请输入纬度  （-90（南纬90°）--90（北纬90°）） ");
    ilon =  input("请输入经度  （0（本初子午线）-- 东经 -- 180  --西经 --）");
    theta =  input("请输入地球站仰角（5°-90°），其他情况推荐您用逐线计算法 ");
    if theta<5 || theta>90
        disp("推荐您用逐线计算法")
    else
        yangjiaodeqingxielujingshuaijian;
    end
end