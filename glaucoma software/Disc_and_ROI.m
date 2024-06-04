clear; close all; clc

path=uigetdir;
f = fullfile(path);
addpath(genpath(f));
% Imds = imageDatastore(f,'IncludeSubFolders',true,'FileExtensions','.jpg','LabelSource','foldernames');
Imds = imageDatastore(f,'FileExtensions','.jpg','LabelSource','foldernames');

names = cell(1,length(Imds.Files));
for i = 1:length(Imds.Files)
    parts = strsplit(Imds.Files{i}, '\');
    names{i} = parts{end};
end

sizes_ROI = [701 701];

for aa = 134:length(names)  
    
    file = names{aa};
    I = imread(file);
    
    I_g = im2double(rgb2gray(I));
    
    sizes = size(I);
    n_pixel = sizes(1)*sizes(2);
    
    I1 = I(:,:,1);
    I2 = I(:,:,2);
    I3 = I(:,:,3);
     
    I1 = adapthisteq(I1);
    I2 = adapthisteq(I2);
    I3 = adapthisteq(I3);
    
    m1 = double([max(max(I1)) min(min(I1)) mean2(I1) std2(I1)]);
    m2 = double([max(max(I2)) min(min(I2)) mean2(I2) std2(I2)]);
    m3 = double([max(max(I3)) min(min(I3)) mean2(I3) std2(I3)]);
    
    threshold = [min([0.99 m1(3)*1.2/255]),m2(3)*1.3/255,m3(3)*1.2/255];
    
    IB1 = imbinarize(I1,threshold(1));
    IB2 = imbinarize(I2,threshold(2));
    IB3 = imbinarize(I3,threshold(3));
    
    contraste = stdfilt(IB1); 
    cont(1) = sum(contraste(:));
    contraste = stdfilt(IB2); 
    cont(2) = sum(contraste(:));
    contraste = stdfilt(IB3); 
    cont(3) = sum(contraste(:));

    pixelesEnComun = sum(IB2(:) & IB1(:));
    p1 = (pixelesEnComun / max(sum(IB2(:)==1),sum(IB1(:)==1))) * 100;   
    pixelesEnComun = sum(IB2(:) & IB3(:));
    p3 = (pixelesEnComun / max(sum(IB2(:)==1),sum(IB3(:)==1))) * 100;
    
    I4 = ones(sizes(1), sizes(2));
    
    if m1(3)<180 || sum(IB1(:))<n_pixel*0.4 && cont(1)<4*10^4 && sum(IB1(:))>n_pixel*0.1  && p1>10
        I4 = I4 .* IB1;
    end
    
    if m2(3)>30 && sum(IB2(:))<n_pixel*0.4 && cont(2)<4*10^4
        I4 = I4 .* IB2;
    end
    
    if m3(3)>30 && sum(IB3(:))<n_pixel*0.4 && cont(3)<4*10^4 && p3>10
        I4 = I4 .* IB3;        
    end
    
    see = strel('disk',20);
    see1 = strel('disk',10);
    see2 = strel('disk',5);
    
    I4 = imclose(I4,see2);
    I5 = imerode(I4,see2);
    I6 = imdilate(I5,see);
    
    I6 = imbinarize(I6,0);
    
    I7 = activecontour(I_g, I6, 'Chan-vese');
    I8 = activecontour(I_g, I6, 'edge');
    I9 = I7+I8;
    I9 = imbinarize(I9,0);
    
    Disc = bwareafilt(I9,[1000 10000000000]);
    Disc = bwareafilt(Disc,3);
    Disc = imfill(Disc, 'holes');

    imshow(Disc)
    
    [posiciones_y, posiciones_x] = ind2sub(size(Disc), find(Disc==1));
    % plot(posiciones_x,posiciones_y,'*')
    
    centro_x1 = round(mean(posiciones_x));
    centro_y1 = round(mean(posiciones_y));
    
    % Definir el radio máximo
    radio_maximo = 300;
    % rectangle('Position', [centro_x1-radio_maximo, centro_y1-radio_maximo, 2*radio_maximo, 2*radio_maximo], 'Curvature', [1, 1], 'EdgeColor', 'r', 'LineWidth', 2);
    
    % Crear un vector de ángulos desde 0 hasta 360 grados
    % angulos = linspace(0, 2*pi, 360);
    angulos = linspace(0, 2*pi, 20);
    
    % Inicializar un vector para almacenar las coordenadas del último píxel blanco
    ultimos_pixeles = zeros(size(angulos));
    
    x_border = zeros(1,length(angulos));
    y_border = zeros(1,length(angulos));
    ultimo_radio = zeros(1,length(angulos));
    
    % Recorrer cada ángulo
    for i = 1:length(angulos)
        % Calcular las coordenadas del punto final de la línea
        x_final = round(centro_x1 + radio_maximo * cos(angulos(i)));
        y_final = round(centro_y1 + radio_maximo * sin(angulos(i)));
    
        % Obtener el perfil de intensidad a lo largo de la línea
        perfil = improfile(Disc, [centro_x1, x_final], [centro_y1, y_final],radio_maximo);
    %     plot([centro_x1, x_final], [centro_y1, y_final]) %plotear las lineas
    
        % Encontrar los índices de los píxeles blancos en el perfil
        indices_blancos = find(perfil > 0);
    
        if isempty(indices_blancos)
            ultimo_radio(i)=300;
        else
            % Almacenar las coordenadas del último píxel blanco
            ultimo_radio(i) = indices_blancos(end);    
        end
    
        x_border(i) = round(centro_x1 + ultimo_radio(i) * cos(angulos(i)));
        y_border(i) = round(centro_y1 + ultimo_radio(i) * sin(angulos(i)));
    end
       
        distancia_media = mean(ultimo_radio);
    
    for i = 2:length(angulos)
        if abs(ultimo_radio(i)-ultimo_radio(i-1))>100
            if abs(ultimo_radio(i)-distancia_media)<abs(ultimo_radio(i-1)-distancia_media)
                    x_border(i-1) = round(centro_x1 + ultimo_radio(i) * cos(angulos(i-1)));
                    y_border(i-1) = round(centro_y1 + ultimo_radio(i) * sin(angulos(i-1)));
                    ultimo_radio(i-1) = ultimo_radio(i);
            else
                    x_border(i) = round(centro_x1 + ultimo_radio(i-1) * cos(angulos(i)));
                    y_border(i) = round(centro_y1 + ultimo_radio(i-1) * sin(angulos(i)));
                    ultimo_radio(i) = ultimo_radio(i-1);
            end
        end
    end
    
    centro_x2 = round(mean(x_border));
    centro_y2 = round(mean(y_border));
    distancia_media = mean(ultimo_radio);
    
    threshold2 = m2(3)*0.6/255;
    IB2 = imcomplement(imbinarize(I2,threshold2));
    
    IB2 = imdilate(IB2,strel('disk',10));
    
    radius = distancia_media;
    I3 = zeros(sizes(1:2));
    [x, y] = meshgrid(1:sizes(2), 1:sizes(1));
    I3((x - centro_x2).^2 + (y - centro_y2).^2 <= radius^2) = 1;
    
    IB2 = IB2 .* (I3);
    Disc = Disc+IB2;
    
    Disc = imbinarize(Disc,0);
    Disc = bwareafilt(Disc,1);
    Disc = imfill(Disc, 'holes');
    
    for i = 1:length(angulos)
        % Calcular las coordenadas del punto final de la línea
        x_final = round(centro_x1 + radio_maximo * cos(angulos(i)));
        y_final = round(centro_y1 + radio_maximo * sin(angulos(i)));
    
        % Obtener el perfil de intensidad a lo largo de la línea
        perfil = improfile(Disc, [centro_x1, x_final], [centro_y1, y_final],radio_maximo);
    %     plot([centro_x1, x_final], [centro_y1, y_final]) %plotear las lineas
    
        % Encontrar los índices de los píxeles blancos en el perfil
        indices_blancos = find(perfil > 0);
    
        if isempty(indices_blancos)
            ultimo_radio(i)=300;
        else
            % Almacenar las coordenadas del último píxel blanco
            ultimo_radio(i) = indices_blancos(end);    
        end
    
        x_border(i) = round(centro_x1 + ultimo_radio(i) * cos(angulos(i)));
        y_border(i) = round(centro_y1 + ultimo_radio(i) * sin(angulos(i)));
    end
    
    border = I;
    for i =1:length(x_border)
        border(max(1,y_border(i)-5):min(sizes(1),y_border(i)+5), max(1,x_border(i)-5):min(sizes(1),x_border(i)+5),1)=0;
        border(max(1,y_border(i)-5):min(sizes(1),y_border(i)+5), max(1,x_border(i)-5):min(sizes(1),x_border(i)+5),2)=0;
        border(max(1,y_border(i)-5):min(sizes(1),y_border(i)+5), max(1,x_border(i)-5):min(sizes(1),x_border(i)+5),3)=255;
    end

    n = 350;
    ROI = I(max(1,centro_y1-n):min(sizes(1),centro_y1+n),max(1, centro_x1-n):min(sizes(2),centro_x1+n),:);

    if sum(size(ROI) ~= [701 701 3])
        ROI = imresize(ROI,sizes_ROI); 
    end

    filePath1 = 'images separadas/buena calidad todas/glau/ROI/_buenas/Final/Disc';
    filePath1 = fullfile(filePath1,['Disc_' file]);
    imwrite(border, filePath1);

    filePath2 = 'images separadas/buena calidad todas/glau/ROI/_buenas/Final/ROI';
    filePath2 = fullfile(filePath2,['ROI_' file]);
    imwrite(ROI, filePath2);
    
end