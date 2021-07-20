function Nuclei = ExtractNuclei(imagename,T0,ShowImages)

% T0:         intensity threshold for nucleus identification 
%                   (default: 32)

AreaMin = 1000;       % Nuclear area lower threshold
fsz = 40;               % font-size in nucleus annotation image

% Read images
fprintf(['Processing sample' ' ' imagename '...\n']);
A_dapi = imread([imagename '_ch00_hilo.tif']);
% Filter and segment DAPI channel
Nuclei = (A_dapi >= T0);
% Detect individual Nuclei
Nuclei = bwmorph(Nuclei,'clean');
Nuclei = imclearborder(Nuclei);
[component,Nx] = bwlabel(Nuclei);
Nuclei_annot = uint8(255*Nuclei);
N = 0;              % Number of nuclei
% Extract individual cells
for k=1:Nx    
    C = (component == k);
    Stats = regionprops(C);    
    if Stats.Area>=AreaMin 
        N = N+1;
        Index = int2str(N);
        fprintf(['Extracting nucleus #' Index ' ' '...\n']);
        Nucleus = (component == k);
        Stats = regionprops(Nucleus);
        x = round(Stats.Centroid(1)); y = round(Stats.Centroid(2));        
        Nuclei_annot = insertText(Nuclei_annot,[x-20,y-20],Index,'TextColor','red',...
            'FontSize',fsz,'BoxOpacity',0);
    end;
end;
% Write nuclei enumeration image
ImTitle = strcat(imagename,'_ch00_seg');
if ShowImages
    figure('Position',[100 100 700 500]); 
    imshow(A_dapi,'InitialMagnification','Fit');
    title(imagename);
    figure('Position',[900 100 700 500]); 
    imshow(Nuclei_annot,'InitialMagnification','Fit');
    title(ImTitle);
end;
imwrite(Nuclei_annot,strcat(ImTitle,'.jpg'),'jpg');
%cd ..

end


