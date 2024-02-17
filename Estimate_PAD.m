clear all; clc;
%% Data Standardization 
load('Input.mat'); % Input.mat is a struct file including Data and demographic information of Training set, Holdout set, and CMP set 
[~,ScaleCoef] = mapstd(Input.Train.Data');

InputName = fieldnames(Input);
for i = 1:length(InputName)
     
    Var = getfield(Input,InputName{i});
    Var.Data_S = mapstd('apply',Var.Data',ScaleCoef)';
    Input = setfield(Input,InputName{i},Var);

end

%% Feature Dimension Reduction
[coeff,~,~,~,~,mu] = pca(Input.Train.Data_S,'centered',true); 

InputName = fieldnames(Input);
for i = 1:length(InputName)
    
    Var = getfield(Input,InputName{i});
    Var.Data_SP = (Var.Data_S-mu)*coeff(:,1:500); 
    Input = setfield(Input,InputName{i},Var);

end

%% Model Training
[ModelCoef_set,FitInfo] = lassoglm(Input.Train.Data_SP,Input.Train.Age,'normal','Link','identity','Alpha',0.5,'CV',5,'Lambda',[0.25:0.25:2.5],'MCReps',50);
idxLambdaMinDeviance = FitInfo.IndexMinDeviance;
ModelCoef = [FitInfo.Intercept(idxLambdaMinDeviance);ModelCoef_set(:,idxLambdaMinDeviance)];

%% Estimate brain age and PAD 
InputName = fieldnames(Input);
for i = 1:length(InputName)
    
    Var = getfield(Input,InputName{i});
    Var.BrainAge = glmval(ModelCoef,Var.Data_SP,'identity');
    Var.PAD = Var.BrainAge - Var.Age; 
    Result = setfield(Result,InputName{i},Var);

end

%% Estimate corrected brain age and PAD 
CorrectionCoef = regress(Result.Train.Pred,[Result.Train.Age,Result.Train.Sex,ones(length(Result.Train.Age),1)]);

InputName = fieldnames(Input);
for i = 1:length(InputName)
    
    Var = getfield(Input,InputName{i});
    Var.PAD_corrected = Var.BrainAge - sum(CorrectionCoef'.*[Var.Age,Var.Sex,ones(size(Var.Age,1),1)],2); %ÄêÁä£¬ÐÔ±ð  
    Var.BrainAge_corrected = Var.PAD_corrected + Var.Age;
    Result = setfield(Result,InputName{i},Var);

end

%% Model Performance
Input.Train.MAE = mae(Input.Train.Age,Input.Train.BrainAge_corrected);
Input.Train.R = corr(Input.Train.Age,Input.Train.BrainAge_corrected);
Input.Holdout.MAE = mae(Input.Holdout.Age,Input.Holdout.BrainAge_corrected);
Input.Holdout.R = corr(Input.Holdout.Age,Input.Holdout.BrainAge_corrected);

%% Save Results and Parameters
save('Results.mat','Result') ;
save('Coef.mat','ModelCoef','CorrectionCoef') ;