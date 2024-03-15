Code utilized in the paper "Morphological and genetic decoding show heterogeneous patterns of brain aging in chronic musculoskeletal pain"

BA_Train.m: Train a brain age model and apply it on chronic musculoskeletal pain cohorts.
Input_example: Example data for 'BA_Train.m'.
BA_Apply.m: Brain age model used to estimate brain age and PAD of user's dataset.
CellEnrichment.R: Perform cell enrichment analysis.
Geneset Braincell.csv: Gene markers for each brain cell class.
GeneRank.csv: A ranked list of genes utilized for cell enrichment analysis. The first column lists the Gene IDs, while the second column details the strength of their correlation with KOA imaging phenotypes.
GreyMask_02_61x73x61.img: A mask used to resample smoothed GMV file and extract grey matter volume. 
ModelCoef.mat：Coefficient of brain age model.
Coef_Main.mat：Parameters for Standardization, brain age estimate, and PAD/brain age Correction.
Coef_PCA_1-7: Parameters for Feature Dimension Reduction.
Coef_PCA_1-7: Parameters for Feature Dimension Reduction.
