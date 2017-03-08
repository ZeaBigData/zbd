### Jinliang Yang
### March 8th, 2017

# https://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?view=search_obj
# search ["maize" OR "zea mays"]
# ["zea"]

m <- read.csv("data/SraRunInfo_zea_03082017.csv")



checksra <- function(info, Gb=100){
  library(tidyr)
  library(plyr)
  info$bases <- as.numeric(info$bases)
  info <- subset(info, bases > Mb*1000000)
  pro <- length(unique(info$BioProject))
  tab <- ddply(info[, c("BioProject", "bases", "Experiment", "ReleaseDate", "Submission", "CenterName")],
               .(Submission, ReleaseDate, CenterName), summarise,
               tot = round(sum(bases)/1000000000, 0))
  tab <- tab[order(tab$ReleaseDate, decreasing = TRUE),]
  tab$year <- gsub("-.*", "", tab$ReleaseDate)
  #tab <- ddply(info, su)
  message(sprintf("###>>> tot submission [ %s ] and [ %s ] > %s Gb", 
                  nrow(tab), nrow(subset(tab,tot > Gb) ), Gb))
  return(tab)
}

####
tab <- checksra(info=m2, Gb=100)
###>>> tot submission [ 577 ] and [ 91 ] > 100 Gb
head(subset(tab, tot > 100 & CenterName != "JGI"), 30)
tab2 <- tab[order(tab$year, tab$tot, decreasing = TRUE),]

res <- ddply(tab2, .(year), summarize,
             tot = sum(tot))
res$asum <- cumsum(res$tot)
plot(res$year, res$asum, type="l", lwd=3)


library(plyr)

getsum <- function(info){
  info$year <- gsub("\\-.*", "", info$ReleaseDate)
  info <- subset(info, year != "")
  info$year <- as.numeric(as.character(info$year))
  #info$year <- 2000 + info$year
  
  #years <- 2010:2016 #at which x-es do you want to show the counts
  df <- ddply(info, .(year), summarize,
              bps = sum(bases))
  
  df$bps <- df$bps/10^12
  df$cums <- cumsum(df$bps)
  return(df)
}




df2 <- getsum(info=m) #maize 
pdf("graphs/ncbi_sra.pdf", width=6,height=5)
par(mar=c(3,5,4,2), bg="#f5f5dc")
plot(df2$year, df2$cums, type="l", lwd=3, main="Sequencing Data in NCBI SRA",  col="#008b8b",
     xlab="", ylab=expression("Base-pairs (Tera," * 10^12 * ")") )
dev.off()


tb <- as.data.frame(table(m$LibraryStrategy))
tb$Var1 <- as.character(tb$Var1)
tb <- subset(tb, !(Var1 %in% c("other", "OTHER")))
tb <- tb[order(tb$Freq, decreasing = TRUE), ]
pdf("graphs/ncbi_sra_tb.pdf", width=6, height=5)
par(mar=c(7,5,4,2), bg="#f5f5dc")
x <- barplot(height=log10(tb$Freq), ylab="Runs (log10)", xaxt="n", col="#458b74")
labs <- as.character(tb$Var1)
text(cex=1, x=x+0.5, y=-0.15, labs, xpd=TRUE, srt=45, pos=2, font=2)
dev.off()

