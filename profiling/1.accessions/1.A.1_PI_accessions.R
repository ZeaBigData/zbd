### Jinliang Yang
### 02-08-2017



install.packages("xtable")
library("xtable")
d <- read.csv("data/export_2017_02_07_03_48_11.csv")

print(xtable(d[1:10,]), type = "html")

#install.packages("xtable")
library("xtable")
d <- read.csv("~/Documents/Github/ZeaBigData/data/export_2017_02_07_03_48_11.csv")

print.xtable(xtable(d[1:1000,]), type = "html", ,sanitize.text.function=function(x){x})

