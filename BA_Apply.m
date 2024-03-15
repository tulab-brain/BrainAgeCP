clc; clear all;
cd ('D:\BrainAge\2020311\Paper\NMH\Response\Picture\Check\Code');
%% Load parameter of PCA
load('Coef_PCA_1');load('Coef_PCA_2');load('Coef_PCA_3');load('Coef_PCA_4');
load('Coef_PCA_5');load('Coef_PCA_6');load('Coef_PCA_7');load('Coef_Main');
Coef_PCA = [PCAcoef_1,PCAcoef_2,PCAcoef_3,PCAcoef_4,PCAcoef_5,PCAcoef_6,PCAcoef_7];

%% Load smoothed (4*4*4) and resliced MRI data (4*4*4)
% Set each cohort as a field of a struct where GMV feature, chronological age and sex were named as 'Data','Age' and 'Sex'(male:1, female:0).
% each row of 'Data' matrix represents GMV feature of one subject (image should be reshape to a vector). 
load('Input_example.mat'); 
InputName = fieldnames(Input);

%% Data Standardization 
for i = 1:length(InputName)
     
    Var = getfield(Input,InputName{i});
    Var.Data_S = mapstd('apply',Var.Data',Coef_Scale)';
    Input = setfield(Input,InputName{i},Var);

end

%% Feature Dimension Reduction
for i = 1:length(InputName)
    
    Var = getfield(Input,InputName{i});
    Var.Data_SP = (Var.Data_S-PCAmu)*Coef_PCA; 
    Input = setfield(Input,InputName{i},Var);

end

%% Estimate brain age and PAD 
for i = 1:length(InputName)
    
    Var = getfield(Input,InputName{i});
    Var.BrainAge = glmval(Coef_Model,Var.Data_SP,'identity');
    Var.PAD = Var.BrainAge - Var.Age; 
    Input = setfield(Input,InputName{i},Var);

end

%% Estimate corrected brain age and PAD 
for i = 1:length(InputName)
    
    Var = getfield(Input,InputName{i});
    Var.PAD_corrected = Var.BrainAge - sum(Coef_Correction'.*[Var.Age,Var.Sex,ones(size(Var.Age,1),1)],2);   
    Var.BrainAge_corrected = Var.PAD_corrected + Var.Age;
    Input = setfield(Input,InputName{i},Var);

end
