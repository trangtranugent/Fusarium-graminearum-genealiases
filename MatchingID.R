setwd("C:/Users/mitran/OneDrive - UGent/Desktop/Siel")

library(openxlsx)
#1. GeneAliases of Fusarium graminearum from fungiDB----
data1=read.xlsx("C:/Users/mitran/OneDrive - UGent/Desktop/Siel/FungiDB-68_FgraminearumPH-1_GeneAliases_20251209.xlsx",
               startRow=1, colNames=TRUE, 
               skipEmptyRow=TRUE, rowNames=FALSE)
data1 <-data1[,c(1,3)]
#2. Convert gene ID_1 (FGRAMPH1_*) into UNIPARC ID via https://biit.cs.ut.ee/gprofiler/convert ----

data2=read.xlsx("C:/Users/mitran/OneDrive - UGent/Desktop/Siel/gProfiler_fgraminearum_09-12-2025_17-25-44.xlsx",
                startRow=1, colNames=TRUE, 
                skipEmptyRow=TRUE, rowNames=FALSE)
data2<-data2[,c(1:2)]
colnames(data2)[1]<-"GeneID_1"
colnames(data2)[2]<-"UPAC_ID"

#3. Convert UniParc into UniProt via https://www.uniprot.org/id-mapping ----
data3=read.xlsx("C:/Users/mitran/OneDrive - UGent/Desktop/Siel/idmapping_2025_12_09_uniprot.xlsx",
                startRow=1, colNames=TRUE, 
                skipEmptyRow=TRUE, rowNames=FALSE)
colnames(data3)[1]<-"UPAC_ID"
data3_filtered <- subset(data3, grepl("FGRAMPH1", Gene.Names))


#Match data3 and data2 by UPAC_ID
data23 <- merge(data2, data3_filtered, by = "UPAC_ID")
#Match data23 and data1 by GeneID_1
meta_data <- merge(data23, data1, by = "GeneID_1")
colnames(meta_data)[3]<-"Protein.Group"
colnames(meta_data)[5]<-"Protein.Names"
meta_data_clean<-meta_data[,-c(4,6,7)]
library(writexl)
write_xlsx(meta_data_clean, "meta_data_clean_FG_TTM.xlsx")
