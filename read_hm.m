function [hm]=read_era15_hm(ilat,ilong)
% determine mean level height [12,32] for each month
% input:
%	ilat= latitude index [1..121]
%  ilong = longitude index [1..240]
% 	ilat = ilong = -1 : close the input file 
% output
%	vd= height profile [m]
% Relase 1.1 2021/01/28
% by Guanyu Liu

persistent fid 

if ((ilat == -1) & (ilong == -1))
   if ~isempty(fid)
      fclose(fid);
      clear fid;
   end
   hm=[];
else
    if isempty(fid)
		fid=fopen('hght.bin','r','ieee-be');
	end   
	lrec=1536;
	ipos=((ilong-1)+(ilat-1)*241).*lrec;
	fseek(fid,ipos,'bof');
	hm=fread(fid,[12,32],'single');
	hm=hm;
end

return
