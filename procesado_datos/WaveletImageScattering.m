% The following code loads the images and splits them into training and testing. 
% Then builds the Wavelet Image Scattering Network and gathers the scattering features into a single
% matrix to finally save them.

% paths of the files
f_glau = fullfile('glau','ROI_2','ROI_fino','RGB_extraction','red'); 
f_norm = fullfile('norm','ROI_2','ROI_fino','RGB_extraction','red'); 

Imds_glau = imageDatastore(f_glau,'FileExtensions','.jpg','LabelSource','foldernames');
Imds_norm= imageDatastore(f_norm,'FileExtensions','.jpg','LabelSource','foldernames');

rng("default") %for reproductibility

Imds_glau = shuffle(Imds_glau); % mix them
Imds_norm = shuffle(Imds_norm);

[trainImds_glau, testImds_glau] = splitEachLabel(Imds_glau,0.8); % split into training and testing
Ttrain_glau = tall(trainImds_glau);
Ttest_glau = tall(testImds_glau);

[trainImds_norm, testImds_norm] = splitEachLabel(Imds_norm,0.8);
Ttrain_norm = tall(trainImds_norm);
Ttest_norm = tall(testImds_norm);

 sn = waveletScattering2('ImageSize',[300 300],'InvarianceScale',125,'QualityFactors',[1 1],'NumRotations',[6 6]); 

% sn = waveletScattering2('ImageSize',[300 300],'InvarianceScale',a,'QualityFactors',[b c],'NumRotations',[6 6]); 

% You can change the variables a, b and c
%     a: the parameter a is the invariance scale of the transform
%     b: the parameter b is the quality factor of the first layer 
%     c: the parameter c is the quality factor of the following layers  

% the mean of the scatering features is obtainede along the x and y dimension
trainfeatures_glau = cellfun(@(x)ScatImages_mean(sn,x),Ttrain_glau,'UniformOutput',false); 
testfeatures_glau = cellfun(@(x)ScatImages_mean(sn,x),Ttest_glau,'UniformOutput',false);

trainfeatures_norm = cellfun(@(x)ScatImages_mean(sn,x),Ttrain_norm,'UniformOutput',false);
testfeatures_norm = cellfun(@(x)ScatImages_mean(sn,x),Ttest_norm,'UniformOutput',false);

Trainf_glau = gather(trainfeatures_glau);
trainfeatures_glau = cat(2,Trainf_glau{:});
Testf_glau = gather(testfeatures_glau);
testfeatures_glau = cat(2,Testf_glau{:});

Trainf_norm = gather(trainfeatures_norm);
trainfeatures_norm = cat(2,Trainf_norm{:});
Testf_norm = gather(testfeatures_norm);
testfeatures_norm = cat(2,Testf_norm{:});

% % you can save the features
% writematrix(trainfeatures_glau, 'TrainingFeatures_glau_gray.csv');
% writematrix(testfeatures_glau, 'TestingFeatures_glau_gray.csv');
% writematrix(trainfeatures_norm, 'TrainingFeatures_norm_gray.csv');
% writematrix(testfeatures_norm, 'TestingFeatures_norm_gray.csv');

writematrix(trainfeatures_glau, 'TrainingFeatures_glau_red.csv');
writematrix(testfeatures_glau, 'TestingFeatures_glau_red.csv');
writematrix(trainfeatures_norm, 'TrainingFeatures_norm_red.csv');
writematrix(testfeatures_norm, 'TestingFeatures_norm_red.csv');

function features = ScatImages_mean(sn,x)
x = imresize(x,[300 300]);
smat = featureMatrix(sn,x);
features = mean(mean(smat,2),3);
end
