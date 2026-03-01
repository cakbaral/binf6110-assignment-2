# binf6110-assignment-2

## Introduction

## Methods
The raw data for the *Saccharomyces cerevisiae* I-329 strain originated from the study conducted by Kishkovskaia et al., which were then investigated in the bulk transcriptomics experiment conducted by Mardanov et al. at three different experimental stages of Velum biofilm: early, thin, and mature (2020, 2017).  The transcriptome sequences for the three replicates investigated at each stage was obtained from NCBI, for a total of 9 different samples (Mardanov et al., 2020, Kishkovskaia et al., 2019, Institute of Bioengineering, Research Center of Biotechnology of RAS, 2019).  Data for the reference transcriptome, including raw sequences and annotation data, were obtained from the R16 genome assembly of *S. cerevisiae* strain S288C on the NCBI RefSeq database (Saccharomyces Genome Database, 2014).  Transcript-level expression and abundance of each replicate was then quantified using quasi-mapping with Salmon v1.10.3, and the Salmon index was constructed from the RNA transcript sequences of the S288C strain (Patro et al., 2017).

Differential expression analysis was conducted on the quantified replicates in R (v4.5.2) using the DESeq2 pseudoaligner (v1.50.2) (Love et al., 2014, Rdocumentation, n.d.).  The differences in gene expression were evaluated statistically using pairwise comparisons between experimental groups according to the multiple-comparison adjusted p-values (padj), using the early biofilm as the primary reference (thin vs. early & mature vs. early) and the thin biofilm as the secondary reference (mature vs. thin).  For visualizations (heatmap, MA plot, volcano plot per comparison), shrinkage was applied to the log2FoldChange (LFC) of genes for each comparison using the ashr shrinkage method (Stephens, 2017).  In particular, for the heatmaps, the top 20 genes were selected based on p-value for visualization.  Lastly, functional annotation and comparison was also conducted in R using the clusterProfiler (v4.18.4), enrichplot (v1.30.4), and org.Sc.sgd.db (v3.22.0) packages (Xu et al., 2024, Yu et al., 2012, Carlson, 2025).  The genes were ranked in order by Wald statistic and analyzed using Gene Ontology (GO)-enriched Fast Gene Set Enrichment Analysis (FGSEA) by biological processes, with a p-value cutoff of 0.05 (Ashburner et al., 2000, The Gene Ontology Consortium, 2025, Thomas et al., 2021, Korotkevich et al., 2016).  Upregulated and downregulated gene sets were compared and visualized separately using dot plots and ridge plots.

## Results

<img width="1852" height="935" alt="Velum_PCA_Plot" src="https://github.com/user-attachments/assets/dc4ea8c4-a0b4-46d3-a70e-48e2af02b7d3" />
**Figure 1**: PCA plot of *S. cerivisiae* replicates at three different stages of Velum biofilm development: early, thin, and mature.  The replicates were quantified using Salmon v.10.3 and analyzed using DESeq2 v1.50.2. 


<img width="1817" height="842" alt="Velum_thin_early_heatmap" src="https://github.com/user-attachments/assets/b2a7a3a3-08bf-4131-a96c-c00a16b53b76" />
<img width="1800" height="797" alt="Velum_mature_early_heatmap" src="https://github.com/user-attachments/assets/db419954-5de8-4b4e-bdb9-6a21392beca4" />
<img width="1782" height="752" alt="Velum_mature_thin_heatmap" src="https://github.com/user-attachments/assets/80ff6a98-5725-4969-83a6-2ac75e32d0aa" />

<img width="1765" height="707" alt="Velum_thin_early_MA_plot" src="https://github.com/user-attachments/assets/52114f8d-bf2b-40cc-b682-9386ef785b60" />
<img width="1750" height="665" alt="Velum_mature_early_MA_plot" src="https://github.com/user-attachments/assets/030c826b-cfc8-44ea-8bf1-c5b16b31e1c1" />
<img width="1732" height="618" alt="Velum_mature_thin_MA_plot" src="https://github.com/user-attachments/assets/80e94f7f-55a0-41ef-ae40-4b7eaa09d2c0" />

<img width="800" height="462" alt="Velum_thin_early_volcano" src="https://github.com/user-attachments/assets/f04f2241-205c-4d41-8c57-4dd687ab7ce2" />
<img width="800" height="462" alt="Velum_mature_early_volcano" src="https://github.com/user-attachments/assets/cea936f5-0735-4b1c-a485-86da520a95ec" />
<img width="800" height="462" alt="Velum_mature_thin_volcano" src="https://github.com/user-attachments/assets/d0e6128d-55ca-4207-a31b-ad3c33d4ca8b" />

<img width="1920" height="1112" alt="Velum_thin_early_dotplot" src="https://github.com/user-attachments/assets/09a47cd6-dfaf-4db7-9d53-8e4e04fec247" />
<img width="1920" height="1112" alt="Velum_mature_early_dotplot" src="https://github.com/user-attachments/assets/275ba667-0f10-47ed-a73e-354b65937aa5" />
<img width="1920" height="1112" alt="Velum_mature_thin_dotplot" src="https://github.com/user-attachments/assets/59ed0c12-64c2-41fe-b41b-7a46c4802511" />

<img width="1920" height="1112" alt="Velum_thin_early_ridgeplot" src="https://github.com/user-attachments/assets/3c4774db-fbfb-435b-80b9-c2f0e56b7f66" />
<img width="1920" height="1112" alt="Velum_mature_early_ridgeplot" src="https://github.com/user-attachments/assets/aa0b8bfc-316a-49a3-9802-adef0b0f1cfc" />
<img width="1920" height="1112" alt="Velum_mature_thin_ridgeplot" src="https://github.com/user-attachments/assets/9fe900b8-af5e-40e4-9598-2ed80b68aaba" />

## Discussion

## References
Ashburner, M., Ball, C. A., Blake, J. A., Botstein, D., Butler, H., Cherry, J. M., Davis, A. P., Dolinski, K., Dwight, S. S., Eppig, J. T., Harris, M. A., Hill, D. P., Issel-Tarver, L., Kasarskis, A., Lewis, S., Matese, J. C., Richardson, J. E., Ringwald, M., Rubin, G. M., & Sherlock, G. (2000). Gene Ontology: tool for the unification of biology. *Nature Genetics*, *25*, 25-29. https://doi.org/10.1038/75556

Carlson, M. (2025). org.Sc.sgd.db: Genome wide annotation for Yeast. *Bioconductor*. https://doi.org/doi:10.18129/B9.bioc.org.Sc.sgd.db

The Gene Ontology Consortium. (2025). The Gene Ontology knowledgebase in 2026. *Nucleic Acids Research*, *54*(D1), D1779-D1792. https://doi.org/10.1093/nar/gkaf1292

Kishkovskaia, S. A., Eldarov, M. A., Dumina, M. V., Tanashchuk, T. N., Ravin, N. V., & Mardanov, A. V. (2017). Flor yeast strains from culture collection: Genetic diversity and physiological and biochemical properties. *Applied Biochemistry and Microbiology*, *53*, 359–367. https://doi.org/10.1134/S0003683817030085

Mardanov, A. V., Eldarov, M. A., Beletsky, A. V., Tanashchuk, T. N., Kishkovskaya, S. A., & Ravin, N. V. (2020). Transcriptome Profile of Yeast Strain Used for Biological Wine Aging Revealed Dynamic Changes of Gene Expression in Course of Flor Development. *Frontiers in Microbiology*, *11*:538. https://doi.org/10.3389/fmicb.2020.00538

Institute of Bioengineering, Research Center of Biotechnology of RAS. (2019). Saccharomyces cerevisiae strain:I-329 (brewer's yeast). *NCBI*. https://www.ncbi.nlm.nih.gov/bioproject/PRJNA592304

Korotkevich, G., Sukhov, V., Budin, N., Shpak, B., Artyomov, M. N., & Sergushichev, A. (2016). Fast gene set enrichment analysis [Preprint]. *bioRxiv*, 060012. https://doi.org/10.1101/060012

Love, M. I., Huber, W., & Anders, S. (2014). Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2. *Genome Biology*, *15*(12), 550. https://doi.org/10.1186/s13059-014-0550-8

Patro, R., Duggal, G., Love, M. I., Irizarry, R. A., & Kingsford, C. (2017). Salmon provides fast and bias-aware quantification of transcript expression. *Nature Methods*, *14*, 417-419. https://doi.org/10.1038/nmeth.4197

Rdocumentation. (n.d.). results: Extract results from a DESeq analysis. https://www.rdocumentation.org/packages/DESeq2/versions/1.12.3/topics/results

Saccharomyces Genome Database (2014). *Saccharomyces cerivisiae* - Genome assembly R64. *NCBI*. https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000146045.2/

Stephens, M. (2017). False discovery rates: a new deal. *Biostatistics*, *18*(2), 275-294. https://doi.org/10.1093/biostatistics/kxw041

Thomas, P. D., Ebert, D., Muruganujan, A., Mushayahama, T., Albou, L. P., & Mi, H. (2021). PANTHER: Making genome‐scale phylogenetics accessible to all. *Protein Science*, *31*(1), 8-22. https://doi.org/10.1002/pro.4218

Xu, S., Hu, E., Cai, Y., Xie, Z., Luo, X., Zhan, L., Tang, W., Wang, Q., Liu, B., Wang, R., Xie, W., Wu, T., Xie, L., & Yu, G. (2024). Using clusterProfiler to characterize multiomics data. *Nature Protocols*, *19*, 3292-3320. https://doi.org/10.1038/s41596-024-01020-z

Yu, G., Wang, L. G., Han, Y., & He, Q. Y. (2012). clusterProfiler: an R Package for Comparing Biological Themes Among Gene Clusters. *OMICS: A Journal of Integrative Biology*, *16*(5), 284-287. https://doi.org/10.1089/omi.2011.0118
