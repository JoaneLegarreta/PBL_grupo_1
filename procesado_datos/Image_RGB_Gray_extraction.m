% The following code extracts induvidual 2D RGB channels (red, blue, green)
% and the grayscale image and stores them in the selected OutputFolders.
% The images are resized to [300 300] before being stored.

OutputFolder_red = 'RGB_extraction\red';  
OutputFolder_green = 'RGB_extraction\green'; 
OutputFolder_blue = 'RGB_extraction\blue';
OutputFolder_gray = 'RGB_extraction\gray';

dinfo = dir('*.jpg');  
sizes = [300 300];

for k = 1:length(dinfo) 
    
    thisimage = dinfo(k).name;  
    Img = imread(thisimage); 
    Y = imshow(Img); 
    
    RedChannel = Img(:,:,1); 
    RedChannel = imresize(RedChannel, sizes);  
    imwrite(RedChannel, fullfile(OutputFolder_red, thisimage));

    GreenChannel = Img(:,:,2);
    GreenChannel = imresize(GreenChannel, sizes);  
    imwrite(GreenChannel, fullfile(OutputFolder_green, thisimage));

    BlueChannel = Img(:,:,3);
    BlueChannel = imresize(BlueChannel, sizes);
    imwrite(BlueChannel, fullfile(OutputFolder_blue, thisimage));
    
    GrayLevel = rgb2gray(Img);
    GrayLevel = imresize(GrayLevel, sizes);  
    imwrite(GrayLevel, fullfile(OutputFolder_gray, thisimage));

end