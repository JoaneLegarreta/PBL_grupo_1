function classificationNeuralNetwork = modelo_final(~)

    TrainingFeatures_norm = readmatrix("TrainingFeatures_norm_gray.csv");
    TrainingFeatures_glau = readmatrix("TrainingFeatures_glau_gray.csv");
    
    X_train = [TrainingFeatures_glau'; TrainingFeatures_norm'];
    Y_train = [ones(size(TrainingFeatures_glau, 2), 1); zeros(size(TrainingFeatures_norm, 2), 1)];
    
    rng(22)
    classificationNeuralNetwork = fitcnet(X_train, Y_train, ...
        'LayerSizes', 10, ...
        'Activations', 'relu', 'Lambda', 0, 'IterationLimit', 1000, ...
        'Standardize', true, 'ClassNames', [false; true]);

end