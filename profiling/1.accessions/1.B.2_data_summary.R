### Jinliang Yang
### 02-28-2017

#### overall data summary

gbs <- read.csv("data/AllZeaGBSv2.7_publicSamples_metadata20140411.csv")

df <- data.frame(table(gbs$Project))
df <- subset(df, Var1 %in% c("2010 Ames Lines", "Ames282", 
                             "NAM", "Old Maize Diversity"))
names(df) <- c("Population", "Size")
df$Type <- c("Inbred", "Inbred", "RIL", "Inbred")
df$GBS <- "yes"
#Type	Size	WGS	GBS	RNA-seq	SNP-Chip"


### Hackathon 2017 annotation
df2 <- data.frame(Population="HZAU panel", Size=522, Type="Inbred", GBS="yes")

df <- rbind(df, df2)
write.table(df, "data/gbs_by_pop.csv", sep=",", row.names=FALSE, quote=FALSE)


#### Visulization
Table <- gvisTable(df, formats=list(Size="#,###"))
plot(Table)



########
meta <- read.csv("data/Meta-data_hackathon2017.csv")
idx1 <- grep("GBS", meta$post_tags)
idx2 <- grep("GBS", meta$post_project)

gbs2 <- meta[c(idx1, idx2), ]

table(meta$post_project)



library(googleVis)
df=data.frame(country=c("WGS", "GBS", "SNP-Chip", "RNA-seq", "ChIP-seq", "MNase"), 
              Geno=c(10,13,14, 10,13,14),
              Size=c(10,13,14, 10,13,14)*2,
              Study=c(1,2,3,1,2,3))

Column <- gvisColumnChart(df)
plot(Column)
