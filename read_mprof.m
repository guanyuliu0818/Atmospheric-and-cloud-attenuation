function [tk,pr,vd,hm]=read_mprof(ilat,ilong)
% extracts the mean monthly vertical profiles at 00, 06, 12 and 18 UTC
% of air temperature, total pressure and vapour density 
% of the pixel located at latitude and longitude indexes ilat and ilon
% 
% It uses input data derived by ESA from analysis of ECMWF ERA15 product.
%
% INPUT
%	ilat= latitude index,    range (1..121) 1=90 2=88.5 121=-90 [deg] 
%   ilong = longitude index, range=(1..240) 1=0 2=1.5 240=358.5 [deg]
% 	N.B. 
%       ilat = ilong = -1 : close the input files
%
% OUTPUT
%  tk: Temperature of air [K],                   size=nlev X nhours*nmonths
%  pr: Air total Pressure [hPa],                 size=nlev X nhours*nmonths
%  vd: Water Vap. density [g/m^3],               size=nlev X nhours*nmonths
%  hm:  height level above mean sea level [m],   size=nlev X nmonths
%
% N.B.
% nlev=32 number of vertical levels
% nhours=4 number of hours 1=00, 2=06, 3=12 and 4=18 UTC 
% nmonths= 12 number of months 1=Jan 12=Dec
%
% e.g. tk(:,1:4),hm(:,1) is the mean vertical profile of 
%         air temperature at 00, 06, 12 and 18 UTC in January 

% Relase 1.1 2021/01/28
% by Guanyu Liu

	tk=read_tk(ilat,ilong);
	pr=read_pr(ilat,ilong);
	vd=read_vd(ilat,ilong);
	hm=read_hm(ilat,ilong);

return
