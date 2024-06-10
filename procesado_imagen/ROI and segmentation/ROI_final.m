%% ROI final - get and save the region of interest in the good quality images

addpath(genpath("images"));

% Seleccionar todas las imagenes de una carpeta
path=uigetdir;
f = fullfile(path);

Imds = imageDatastore(f,'FileExtensions','.jpg','LabelSource','foldernames');
%'IncludeSubFolders',true

names = cell(1,length(Imds.Files));
for i = 1:length(Imds.Files)
    parts = strsplit(Imds.Files{i}, '\');
    names{i} = parts{end};
end

% Donde guardar el ROI
filePath = 'images separadas/comparar ROIs/ROI_2';

sizes = [2424 3004];
pixels = sizes(1)*sizes(2);
sizes_ROI = [801 801];
radius = 1100;
n = 400;

center = [sizes(2)/2, sizes(1)/2];
I3 = zeros(sizes(1:2));
[x, y] = meshgrid(1:sizes(2), 1:sizes(1));
I3((x - center(1)).^2 + (y - center(2)).^2 <= radius^2) = 1;
I3 = uint8(I3);

for i = 1:length(names)  
    
    file = names{i};
    I = imread(file);

    I = imresize(I,sizes); 
    
    I2 = I(:,:,2); %get green channel
    I2 = I2 .* I3;    
    
    [~, indices] = sort(I2(:), 'descend');
    top = indices(1:round(pixels*0.0015)); % get brightest 0.15% of pixels
    
    [posiciones_y, posiciones_x] = ind2sub(size(I2), top);

    meanx = round(mean(posiciones_x));
    meany = round(mean(posiciones_y));
    
    ROI = I(max(1,meany-n):min(sizes(1),meany+n),max(1, meanx-n):min(sizes(2),meanx+n),:);
    
    if sum(size(ROI) ~= [801 801 3])>0
        ROI = imresize(ROI,sizes_ROI); 
    end

    filePath1 = fullfile(filePath,['ROI_' file]);
    imwrite(ROI, filePath1);

end    