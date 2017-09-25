############--------DESeq2---------############
#(1) input file
library("DESeq2")
feature.num=read.table("RNA-seq_gene_count_matrix",header=T,row.names=1)
sample.info=read.table("sample_info",header=T,names=1)

info<-matrix(nrow=6,ncol=2)
row.names(info)<-c('1954','1955','1956','1957','1958','1959')
colnames(info)<-c('type','sample')
info[,1]<-c('cancer','adjacent','cancer','adjacent','cancer','adjacent')
info[,2]<-c('SHBPL000036CAC','SHBPL000036CAC','SHCPL000037CAC','SHCPL000037CAC','SHCPL000029CAC','SHCPL000029CAC')

countData<-count(feature.num)
countData <-as.matrix(feature.num)
colData <- info

#format example
head(countData)
## treated1fb treated2fb treated3fb untreated1fb untreated2fb
## FBgn0000003 0 0 1 0 0
## FBgn0000008 78 46 43 47 89
head(colData)
##          type
## treated1fb single-read
## treated2fb paired-end
## treated3fb paired-end

#(2) DESeq
cfdna<- DESeqDataSetFromMatrix(countData=countData,colData=colData,design=~type+sample)

#Pre-filtering
dds <- dds[ rowMeans(counts(dds))>10,]

#Note on factor levels
dds$type <- factor(dds$type, levels=c("normal","tumor"))

#Collapsing technical replicates
#Differential expression analysis
dds <- DESeq(dds)
res <- results(dds)
res
## baseMean log2FoldChange lfcSE stat pvalue padj
## <numeric> <numeric> <numeric> <numeric> <numeric> <numeric>
## FBgn0000008 52.226 0.0196 0.2095 0.0937 0.9253 0.989

#alternative parallel
library("BiocParallel")
register(MulticoreParam(4))

#(3) order results table by the smallest adjusted p value:
resOrdered <- res[order(res$padj),]

# summarize some basic tallies using the summary function.
summary(res)

#How many adjusted p-values were less than 0.1?
sum(res$padj < 0.1, na.rm=TRUE)

# alpha: an adjusted p value below a given FDR cutoff.
res05 <- results(dds, alpha=0.05)
summary(res05)

# (4) exported using the base R functions write.csv or write.delim. 
write.csv(as.data.frame(resOrdered),file="type_tumor_results.csv")
#Exporting results which pass FDR<0.05 by accomplishing with the subset function
resSig <- subset(resOrdered, padj < 0.05)
