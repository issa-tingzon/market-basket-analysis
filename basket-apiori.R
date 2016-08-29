#Load arules package
library("arules")
library("arulesViz")

#Set Working directory and read data
setwd("C:/Users/issa/Dropbox/CS176-PA1-2S14-15")
#Basket <- read.table("basket.dat")
Basket <- read.transactions("basket.dat", sep=" ", rm.duplicates=TRUE)
transactions <- as(Basket, "transactions")

#Generate Association Rules using Apriori Algo
rules <- apriori(Basket, parameter = list(support = 0.01, conf = 0.8))

rules.lhs.supp <- support(rules@lhs, Basket, type= c("relative", "absolute"), control = NULL)
rules.rhs.supp <- support(rules@rhs, Basket, type= c("relative", "absolute"), control = NULL)
rules.union.supp <- support(rules, Basket, type= c("relative", "absolute"), control = NULL)
#confidence.true <- rules.union.supp/rules.lhs.supp

#Caculate Imbalance Ratio
imbalance_ratio <- abs(rules.lhs.supp - rules.rhs.supp)/ (rules.lhs.supp + rules.rhs.supp - rules.union.supp) #rules.union.supp = (quality(rules)$support)
quality(rules) <- cbind(quality(rules), imbalance_ratio)

#Calculate Kulc
kulc <- (1/2)*((rules.union.supp/rules.lhs.supp) + (rules.union.supp/rules.rhs.supp))
quality(rules) <- cbind(quality(rules), kulc)

#Pruning Redundant Rules
#Source: http://www.rdatamining.com/examples/association-rules
rules.sorted.lift <- sort(rules, by="lift")
subset.matrix <- is.subset(rules.sorted.lift, rules.sorted.lift)
subset.matrix[lower.tri(subset.matrix, diag=T)] <- NA
redundant <- colSums(subset.matrix, na.rm=T) >= 1
rules.pruned <- rules.sorted.lift[!redundant]

rules.pruned <- sort(rules.pruned, decreasing = TRUE, by="support")

inspect(rules.pruned[1:10])

#plot(rules.pruned, method="paracoord", control=list(reorder=TRUE))
plot(rules.pruned)
#plot(rules.pruned, method="graph")
