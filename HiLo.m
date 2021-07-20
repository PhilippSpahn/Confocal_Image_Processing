function HiLo(basename,a_low,a_high,range,channel)

% APPLIES LOWPASS/HIGHPASS FILTERING TO IMAGE SERIES
%
% basename:                 Basename of data series
% a_low:                    Lowpass parameter (typically 1-4)
% a_high:                   Highpass parameter (typically 500-5000)
% range:                    Image series range
% channel:                  Which channel? ('ch00'/'ch01')
%
% ============================================================


for i = range
    if i<=9
        name = strcat(basename,'_Series00',int2str(i),'_',channel);
    elseif i <= 99
        name = strcat(basename,'_Series0',int2str(i),'_',channel);
    else
        name = strcat(basename,'_Series',int2str(i),'_',channel);
    end;
    A = imread([name '.tif']);
    At = lowpass(A,a_low);
    Ah = highpass(At,a_high);
    name_output = strcat(name,'_hilo.tif');
    imwrite(Ah,name_output,'TIF');    
    figure; imshow(Ah);
    if length(range) > 1
        close all;
    end;
end;

end