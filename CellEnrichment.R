rm(list=ls())
library(DOSE)
library(clusterProfiler)
library(org.Hs.eg.db)
library(enrichplot)
library(ggplot2)

geneSet = read.csv(file="/Geneset_Braincell.csv",header=TRUE)
geneRank = read.csv(file="/GeneRank.csv",header=TRUE) 
geneList=geneRank[,2]
names(geneList)=as.character(geneRank[,1])
geneList = sort(geneList,decreasing = TRUE)

##
res<-GSEA(geneList,
          pAdjustMethod = "BH", #bonferroni
          pvalueCutoff = 0.05,
          TERM2GENE= geneSet,nPerm = 100000,maxGSSize = 1000,
          by = "fgsea"
)

dotplot(res,showCategory=16,size = 'NES' ,color = 'p.adjust')
gseaplot2(res, geneSetID = c('Ast','Mic'))