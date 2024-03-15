clear all; clc;
%% Data Standardization 
load('Input.mat'); % Input.mat is a struct file including Data and demographic information of Training set, Holdout set, and CMP set 
[~,Coef_Scale] = mapstd(Input.Train.Data');

InputName = fieldnames(Input);
for i = 1:length(InputName)
     
    Var = getfield(Input,InputName{i});
    Var.Data_S = mapstd('apply',Var.Data',Coef_Scale)';
    Input = setfield(Input,InputName{i},Var);

end

%% Feature Dimension Reduction
[Coef_PCA,ScoreTrain,~,~,explained,PCAmu] = pca(Input.Train.Data_S,'centered',true); 
Coef_PCA = Coef_PCA(:,1:500);

for i = 1:length(InputName)
    
    Var = getfield(Input,InputName{i});
    Var.Data_SP = (Var.Data_S-PCAmu)*Coef_PCA(:,1:500); 
    Input = setfield(Input,InputName{i},Var);

end

%% Model Training
[ModelCoef_set,FitInfo] = lassoglm(Input.Train.Data_SP,Input.Train.Age,'normal','Link','identity','Alpha',0.5,'CV',5,'Lambda',[0.25:0.25:2.5],'MCReps',50);
idxLambdaMinDeviance = FitInfo.IndexMinDeviance;
Coef_Model = [FitInfo.Intercept(idxLambdaMinDeviance);ModelCoef_set(:,idxLambdaMinDeviance)];

%% Estimate brain age and PAD 
for i = 1:length(InputName)
    
    Var = getfield(Input,InputName{i});
    Var.BrainAge = glmval(Coef_Model,Var.Data_SP,'identity');
    Var.PAD = Var.BrainAge - Var.Age; 
    Input = setfield(Input,InputName{i},Var);

end

%% Estimate corrected brain age and PAD 
Coef_Correction = regress(Input.Train.Pred,[Input.Train.Age,Input.Train.Sex,ones(length(Input.Train.Age),1)]);

for i = 1:length(InputName)
    
    Var = getfield(Input,InputName{i});
    Var.PAD_corrected = Var.BrainAge - sum(Coef_Correction'.*[Var.Age,Var.Sex,ones(size(Var.Age,1),1)],2);   
    Var.BrainAge_corrected = Var.PAD_corrected + Var.Age;
    Input = setfield(Input,InputName{i},Var);

end

%% Model Performance
Input.Train.MAE = mae(Input.Train.Age,Input.Train.BrainAge_corrected);
Input.Train.R = corr(Input.Train.Age,Input.Train.BrainAge_corrected);
Input.Holdout.MAE = mae(Input.Holdout.Age,Input.Holdout.BrainAge_corrected);
Input.Holdout.R = corr(Input.Holdout.Age,Input.Holdout.BrainAge_corrected);

%% Save Results and Parameters
save('Results.mat','Input') ;
save('Coef.mat','Coef_Scale','Coef_PCA','PCAmu','Coef_Model','Coef_Correction') ;