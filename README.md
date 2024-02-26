Code utilized in the paper "Morphological and genetic decoding show heterogeneous patterns of brain aging in chronic musculoskeletal pain"

Estimate_BrainAge.m: Train a brain age model and apply it on chronic musculoskeletal pain cohorts.
CellEnrichment.R: Perform cell enrichment analysis.
Geneset Braincell.csv: Gene markers for each brain cell class.
GeneRank.csv: A ranked list of genes utilized for cell enrichment analysis. The first column lists the Gene IDs, while the second column details the strength of their correlation with KOA imaging phenotypes.
BrainMask 61x73x61.img: A mask used to resample smoothed GMV file. 
ModelCoef.mat：Coefficient of brain age model.
CorrectionCoef.mat：Correction parameters for brain age and PAD.
