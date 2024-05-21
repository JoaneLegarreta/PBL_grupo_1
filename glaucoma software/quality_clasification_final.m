%% Clasification_thrs_final

clear; close all; clc

addpath(genpath("images"));
Metadata = readtable("metadata.csv");

Revisada = Metadata.quality~=0;
SinRevisar = Metadata.quality==0;

T = Metadata(SinRevisar,:);
[N, P] = size(T);

quality = zeros(length(T.image),1); 
cont = zeros(length(T.image),1); 
SD = zeros(length(T.image),1); 

for i = 1:length(T.image)    
    I = imload(T.image{i});     
    contraste = stdfilt(I);
    cont(i) = sum(contraste(:));
    SD(i) = std2(I(:));

    if SD(i) < 0.1
        quality(i) = 1;
    elseif cont(i) < 7*10^3 
        quality(i) = 2;
    elseif cont(i) > 10^6
        quality(i) = 3;
    elseif SD(i) > 0.25
        quality(i) = 4;
    else
        quality(i) = 5;
    end
end

% Carpeta de origen
carpeta_origen = 'images/';

% Carpetas de destino
carpeta_destino_clase1 = 'images separadas/final/mal contraste';
carpeta_destino_clase2 = 'images separadas/final/desenfoque';
carpeta_destino_clase3 = 'images separadas/final/ruido';
carpeta_destino_clase4 = 'images separadas/final/claras';
carpeta_destino_clase5 = 'images separadas/final/buena calidad';

% lista de archivos 'jpg' en la carpeta de origen
archivos = dir(fullfile(carpeta_origen, '*.jpg'));

for i = 1:N
    nombre_archivo = T.image{i};
    ruta_archivo = fullfile(carpeta_origen, nombre_archivo);
    
    if quality(i) == 1
        carpeta_destino = carpeta_destino_clase1;
    elseif quality(i) == 2
        carpeta_destino = carpeta_destino_clase2;
    elseif quality(i) == 3
        carpeta_destino = carpeta_destino_clase3;
    elseif quality(i) == 4
        carpeta_destino = carpeta_destino_clase4;
    elseif quality(i) == 5
        carpeta_destino = carpeta_destino_clase5;
    else
        % Si no coincide con ninguna clasificación avisar del error
        disp(['No se pudo clasificar el archivo: ', nombre_archivo]);
        continue; % Salta al siguiente archivo
    end
    
    % Copiar el archivo a la carpeta de destino
    destino = fullfile(carpeta_destino, nombre_archivo);
    copyfile(ruta_archivo, destino);
end

function I = imload(file_name)
    I = imread(file_name);
    I = rgb2gray(I);                % escala de grises
    I = imresize(I,[2424 3004]);    % tamaño
    I = im2double(I);               % normalization y fomrato double
end
