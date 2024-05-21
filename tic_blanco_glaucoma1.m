clear; close all; clc
addpath(genpath("images"));
Metadata = readtable("metadata.csv");

Revisada_B = Metadata.quality==4;

T = Metadata(Revisada_B,:);
[N, P] = size(T);

m = zeros(N,1); 
SD = zeros(N,1); 
threshold = zeros(N,1); 

for aa = 1:N
    file = T.image{aa};

    I = imread(file);

    if  tick(aa)==1 
    
        I1 = I(:,:,1);
        I2 = I(:,:,2);
        I3 = I(:,:,3);        
        
%         opción 2
%         meanValue = mean2(I(:,:,1));
%         stdValue = std2(I(:,:,1));
%         k = 1.4;
%         threshold = (meanValue + (stdValue * k));
%         I1 = I1 > threshold;

%         opción 1 - aparentemente mejor resultados
        m(aa) = mean2(I(:,:,1));
        sd(aa) = std2(I(:,:,1));
        
        if sd(aa)>70
            threshold(aa) = (((255*9+m(aa))/10)/255)+0.05;
        else
            threshold(aa) = ((255*9+m(aa))/10)/255;
        end

        I1 = imbinarize(I1,(threshold(aa)));
        I2 = imbinarize(I2,0.65);
        I3 = imbinarize(I3,0.4);
        
        I4 = I1 + I2 + I3;
        
        see = strel('disk',20);
        see2 = strel('disk',25);
        
        I5 = imerode(I4,see);
        I6 = imdilate(I5,see);
        I6 = imclose(I6,see2);
        
        I6 = imbinarize(I6,0);

        filePath = 'images separadas/glaucoma - tick - revisadas4';
        filePath1 = fullfile(filePath,file);
        filePath2 = fullfile(filePath,[file 'd.jpg']);
        imwrite(I, filePath1);
        imwrite(I6, filePath2);
    end
end