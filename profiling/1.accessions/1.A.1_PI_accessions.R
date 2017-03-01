### Jinliang Yang
### 02-08-2017



install.packages("xtable")
library("xtable")
d <- read.csv("data/export_2017_02_07_03_48_11.csv")

print(xtable(d[1:10,]), type = "html")

#install.packages("xtable")
library("xtable")
library(data.table)
d <- fread("~/Documents/Github/ZeaBigData/data/export_2017_02_07_03_48_11.csv", 
           data.table=FALSE)
names(d)


out <- as.data.frame(table(d$Origin))
out <- subset(out, Var1 != "")

out$c1<- gsub(" .*", "", out$Var1)
out$c2 <- gsub("^[[:alpha:]]+\\s", "", out$Var1)

out[out$Var1 == "United Kingdom England", ]$c1 <- "United Kingdom England"

uq <- data.frame(table(out$c1))
output <- data.frame()
for(i in 1:nrow(uq)){
    
    if(uq$Freq[i] > 1){
        sub <- subset(out, c1 %in% uq$Var1[i])
        tem <- subset(sub, c1 == c2)
        if(nrow(tem) == 0){
            tem <- sub[1, ]
            tem$c1 <- tem$Var1
        }
        if(nrow(tem) > 1){
            tem <- tem[1, ]
        }
        tem$Freq <- sum(sub$Freq)
    }else{
        tem <- subset(out, c1 %in% uq$Var1[i])
        tem$c1 <- tem$Var1
    }
    output <- rbind(output, tem)
    message(sprintf("###>>> [ %sth ] country [ %s ]", i, uq$Var1[i]))
}
write.table(output, "data/grin_by_country.csv", sep=",", row.names=FALSE, quote=FALSE)

sub1 <- subset(out, c1 != c2)
sub1$Country <- paste(sub1$c1, sub1$c2)
sub2 <- subset(out, c1 == c2)
sub2$Country <- sub2$c1




library("googleVis")
Geo=gvisGeoChart(out, locationvar="Var1",  colorvar="Freq",
                 options=list(projection="kavrayskiy-vii"))
plot(Geo)
