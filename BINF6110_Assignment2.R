##**************************
## BINF*6110 - Assignment 2
##
## Student Name: Cyrus Akbarally
##
## Student Number: 1099054
##
## 2026-03-01
##
##**************************

## NOTE: For code on quantification, refer to the shell script "Saccharomyces_cerevisiae_I329_quantification.sh".  This R script continues with the analysis after quantification.

rm(list = ls())

## _ Install packages----
## install.packages("tidyverse")
## install.packages("viridis")
## install.packages("dplyr")
## install.packages("ggplot2")
## install.packages("pheatmap")
## install.packages("BiocManager")
## install.packages("ggridges")
## BiocManager::install("DESeq2")
## BiocManager::install("tximport")
## BiocManager::install("clusterProfiler")
## BiocManager::install("org.Sc.sgd.db")
## BiocManager::install("enrichplot")
## BiocManager::install("ashr")
## BiocManager::install("GenomicFeatures")
## BiocManager::install("txdbmaker")


#--

## _ Packages used----
library(tidyverse)
library(viridis)
library(dplyr)
library(ggplot2)
library(pheatmap)
library(ggridges)
library(DESeq2)
library(tximport)
library(clusterProfiler)
library(org.Sc.sgd.db)
library(enrichplot)
library(ashr)
library(GenomicFeatures)
library(txdbmaker)
## setwd("~/BINF6110 Genomic Methods for Bioinformatics/Assignment_2")


#--


## 1. PREPARING THE METADATA AND tx2gene TABLES----


# Metadata table----

sra <- c("SRR10551665", "SRR10551664", "SRR10551663", "SRR10551662", "SRR10551661", "SRR10551660", "SRR10551659", "SRR10551658", "SRR10551657")

sample_id <- c("IL20", "IL21", "IL22", "IL23", "IL24", "IL25", "IL29", "IL30", "IL31")

stage <- factor(c("Early biofilm", "Early biofilm", "Early biofilm", "Thin biofilm", "Thin biofilm", "Thin biofilm", "Mature biofilm", "Mature biofilm", "Mature biofilm"), levels = c("Early biofilm", "Thin biofilm", "Mature biofilm"))

sampleTable <- data.frame(SRA_Accession = sra, SampleID = sample_id, Stage = stage)


# Tx2gene table and importing quantification data----

sampleFile <- c("Velum_IL20_quant.sf", "Velum_IL21_quant.sf", "Velum_IL22_quant.sf", "Velum_IL23_quant.sf", "Velum_IL24_quant.sf", "Velum_IL25_quant.sf", "Velum_IL29_quant.sf", "Velum_IL30_quant.sf", "Velum_IL31_quant.sf")

txdb <- txdbmaker::makeTxDbFromGFF("GCF_000146045.2_R64_genomic.gtf")
k <- keys(txdb, keytype = "TXNAME")
tx2gene <- select(txdb, k, "GENEID", "TXNAME")

txi <- tximport(sampleFile, type = "salmon", tx2gene = tx2gene)


#--


## 2. DIFFERENTIAL EXPRESSION AND COMPARING EXPERIMENTAL GROUPS FOR SIGNIFICANCE----

## "Early biofilm" will be used as reference/baseline for DESeq2 and comparisons.


## DESeq2----

dds <- DESeqDataSetFromTximport(txi, sampleTable, ~Stage)
dds <- DESeq(dds)

resultsNames(dds)


# Thin vs. early
res_dds_1 <- results(dds, name = "Stage_Thin.biofilm_vs_Early.biofilm")
res_dds_1


# Mature vs. early
res_dds_2 <- results(dds, name = "Stage_Mature.biofilm_vs_Early.biofilm")
res_dds_2


# Mature vs. thin (the "contrast" argument is used to retrieve the equivalent of mature vs. thin)
res_dds_3 <- results(dds, contrast = c("Stage", "Mature biofilm", "Thin biofilm"))
res_dds_3


## Applying ashr shrinkage to log2FoldChange for visualization----

# Thin vs. early
resLFC1 <- lfcShrink(dds, coef = "Stage_Thin.biofilm_vs_Early.biofilm", type = "ashr")

# Mature vs. early
resLFC2 <- lfcShrink(dds, coef = "Stage_Mature.biofilm_vs_Early.biofilm", type = "ashr")

# Mature vs. thin
resLFC3 <- lfcShrink(dds, contrast = c("Stage", "Mature biofilm", "Thin biofilm"), type = "ashr")


## PCA Plot of Velum Biofilms----

vsd <- vst(dds)
pca_data <- plotPCA(vsd, intgroup = "Stage", returnData = TRUE)
percentVar <- round(100 * attr(pca_data, "percentVar"))

ggplot(pca_data, aes(x = PC1, y = PC2, color = Stage)) +
  geom_point(size = 4) +
  xlab(paste0("PC1: ", percentVar[1], "% variance")) +
  ylab(paste0("PC2: ", percentVar[2], "% variance")) +
  ggtitle("PCA Plot of Velum Biofilm Samples")
coord_fixed()


## Heatmaps----

resLFC1 <- na.omit(resLFC1)
resLFC2 <- na.omit(resLFC2)
resLFC3 <- na.omit(resLFC3)


# Top 20 genes by p-value

# Thin vs. early
top_genes1 <- head(order(abs(resLFC1$padj), decreasing = FALSE), 20)
gene_names1 <- rownames(resLFC1)[top_genes1]

# Mature vs. early
top_genes2 <- head(order(abs(resLFC2$padj), decreasing = FALSE), 20)
gene_names2 <- rownames(resLFC2)[top_genes2]

# Mature vs. thin
top_genes3 <- head(order(abs(resLFC3$padj), decreasing = FALSE), 20)
gene_names3 <- rownames(resLFC3)[top_genes3]

vsd <- vst(dds)

mat1 <- assay(vsd)[gene_names1, ]
mat2 <- assay(vsd)[gene_names2, ]
mat3 <- assay(vsd)[gene_names3, ]

annotation_df <- sampleTable[, "Stage", drop = FALSE]
colnames(annotation_df) <- c("Stage")

# Thin vs. early
pheatmap(mat1,
  scale = "row",
  cluster_rows = TRUE,
  cluster_cols = TRUE,
  annotation_col = annotation_df,
  show_rownames = TRUE,
  show_colnames = TRUE,
  main = "Velum Gene Heatmap - Thin vs. Early (reference)"
)


# Mature vs. early
pheatmap(mat2,
  scale = "row",
  cluster_rows = TRUE,
  cluster_cols = TRUE,
  annotation_col = annotation_df,
  show_rownames = TRUE,
  show_colnames = TRUE,
  main = "Velum Gene Heatmap - Mature vs. Early (reference)"
)

# Thin vs. mature
pheatmap(mat3,
  scale = "row",
  cluster_rows = TRUE,
  cluster_cols = TRUE,
  annotation_col = annotation_df,
  show_rownames = TRUE,
  show_colnames = TRUE,
  main = "Velum Gene Heatmap - Mature vs. Thin"
)


## MA Plots----

# Thin vs. early
plotMA(resLFC1, ylim = c(-2, 2), main = "Velum Gene MA Plot - Thin vs. Early (reference)")

# Mature vs. early
plotMA(resLFC2, ylim = c(-2, 2), main = "Velum Gene MA Plot - Mature vs. Early (reference)")

# Mature vs. thin
plotMA(resLFC3, ylim = c(-2, 2), main = "Velum Gene MA Plot - Mature vs. Thin")


# Volcano Plots----


# Thin vs early
res_df1 <- as.data.frame(resLFC1)
res_df1$gene <- rownames(res_df1)
res_df1$significant <- ifelse(res_df1$padj < 0.05 & abs(res_df1$log2FoldChange) > 1,
  ifelse(res_df1$log2FoldChange > 0, "Upregulated", "Downregulated"), "Non-Significant"
)
res_df1 <- na.omit(res_df1)

ggplot(res_df1, aes(x = log2FoldChange, y = -log10(pvalue), color = significant)) +
  geom_point() +
  scale_color_manual(values = c("Downregulated" = "blue", "Non-Significant" = "gray", "Upregulated" = "red")) +
  labs(
    x = "Log2 Fold Change", y = "-Log10 p-value",
    title = "Velum Gene Volcano Plot - Thin vs. Early (reference)"
  ) +
  theme(legend.position = "right")


# Mature vs. early
res_df2 <- as.data.frame(resLFC2)
res_df2$gene <- rownames(res_df2)
res_df2$significant <- ifelse(res_df2$padj < 0.05 & abs(res_df2$log2FoldChange) > 1,
  ifelse(res_df2$log2FoldChange > 0, "Upregulated", "Downregulated"), "Non-Significant"
)
res_df2 <- na.omit(res_df2)

ggplot(res_df2, aes(x = log2FoldChange, y = -log10(pvalue), color = significant)) +
  geom_point() +
  scale_color_manual(values = c("Downregulated" = "blue", "Non-Significant" = "gray", "Upregulated" = "red")) +
  labs(
    x = "Log2 Fold Change", y = "-Log10 p-value",
    title = "Velum Gene Volcano Plot - Mature vs. Early (reference)"
  ) +
  theme(legend.position = "right")


# Mature vs. thin
res_df3 <- as.data.frame(resLFC3)
res_df3$gene <- rownames(res_df3)
res_df3$significant <- ifelse(res_df3$padj < 0.05 & abs(res_df3$log2FoldChange) > 1,
  ifelse(res_df3$log2FoldChange > 0, "Upregulated", "Downregulated"), "Non-Significant"
)
res_df3 <- na.omit(res_df3)

ggplot(res_df3, aes(x = log2FoldChange, y = -log10(pvalue), color = significant)) +
  geom_point() +
  scale_color_manual(values = c("Downregulated" = "blue", "Non-Significant" = "gray", "Upregulated" = "red")) +
  labs(
    x = "Log2 Fold Change", y = "-Log10 p-value",
    title = "Velum Gene Volcano Plot - Mature vs. Thin"
  ) +
  theme(legend.position = "right")


#--


## 3. FUNCTIONAL ANNOTATION AND GO-GSEA COMPARISON----

# View the original results with no shrinkage as data frames----

res_df1_no <- as.data.frame(res_dds_1)
res_df2_no <- as.data.frame(res_dds_2)
res_df3_no <- as.data.frame(res_dds_3)


# Convert all gene ORFs to Entrez IDs----

orf_ids1 <- rownames(res_df1_no)
orf_ids_clean1 <- sub("\\..*", "", orf_ids1)

orf_ids2 <- rownames(res_df2_no)
orf_ids_clean2 <- sub("\\..*", "", orf_ids2)

orf_ids3 <- rownames(res_df3_no)
orf_ids_clean3 <- sub("\\..*", "", orf_ids3)


gene_map1 <- bitr(orf_ids_clean1,
  fromType = "ORF",
  toType = c("ENTREZID"),
  OrgDb = org.Sc.sgd.db
)


gene_map2 <- bitr(orf_ids_clean2,
  fromType = "ORF",
  toType = c("ENTREZID"),
  OrgDb = org.Sc.sgd.db
)

gene_map3 <- bitr(orf_ids_clean3,
  fromType = "ORF",
  toType = c("ENTREZID"),
  OrgDb = org.Sc.sgd.db
)

res_df1_no$EntrezID <- gene_map1$ENTREZID
res_df2_no$EntrezID <- gene_map2$ENTREZID
res_df3_no$EntrezID <- gene_map3$ENTREZID


# Ranked lists by Wald statistic from DESeq2----

wald1 <- res_df1_no$stat
genes1 <- res_df1_no$EntrezID
ranked1 <- setNames(wald1, genes1)
ranked1 <- na.omit(ranked1)
ranked1 <- sort(ranked1, decreasing = TRUE)

wald2 <- res_df2_no$stat
genes2 <- res_df2_no$EntrezID
ranked2 <- setNames(wald2, genes2)
ranked2 <- na.omit(ranked2)
ranked2 <- sort(ranked2, decreasing = TRUE)


wald3 <- res_df3_no$stat
genes3 <- res_df3_no$EntrezID
ranked3 <- setNames(wald3, genes3)
ranked3 <- na.omit(ranked3)
ranked3 <- sort(ranked3, decreasing = TRUE)


# GO-GSEA comparison----

gsea1 <- gseGO(ranked1,
  OrgDb = org.Sc.sgd.db,
  ont = "BP",
  keyType = "ENTREZID",
  pvalueCutoff = 0.05
)

gsea2 <- gseGO(ranked2,
  OrgDb = org.Sc.sgd.db,
  ont = "BP",
  keyType = "ENTREZID",
  pvalueCutoff = 0.05
)

gsea3 <- gseGO(ranked3,
  OrgDb = org.Sc.sgd.db,
  ont = "BP",
  keyType = "ENTREZID",
  pvalueCutoff = 0.05
)


# Dot plots for GO-GSEA visualization----

dotplot(gsea1, showCategory = 15, split = ".sign") +
  facet_grid(. ~ .sign) +
  ggtitle("GO Biological Process - Thin vs. Early (reference)")

dotplot(gsea2, showCategory = 15, split = ".sign") +
  facet_grid(. ~ .sign) +
  ggtitle("GO Biological Process - Mature vs. Early (reference)")

dotplot(gsea3, showCategory = 15, split = ".sign") +
  facet_grid(. ~ .sign) +
  ggtitle("GO Biological Process - Mature vs. Thin")


# Ridge plots for GO-GSEA visualization----

ridgeplot(gsea1) +
  labs(title = "GO Biological Process - Thin vs. Early (reference)")

ridgeplot(gsea2) +
  labs(title = "GO Biological Process - Mature vs. Early (reference)")

ridgeplot(gsea3) +
  labs(title = "GO Biological Process - Mature vs. Thin")
