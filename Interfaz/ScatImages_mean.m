function features = ScatImages_mean(sn,x)
x = imresize(x,[300 300]);
smat = featureMatrix(sn,x);
features = mean(mean(smat,2),3);
end