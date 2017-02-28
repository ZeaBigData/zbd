
install.packages("xtable")
library("xtable")
d <- read.csv("data/export_2017_02_07_03_48_11.csv")

print(xtable(d[1:10,]), type = "html")
