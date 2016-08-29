setwd("C:/Users/issa/Dropbox/CS176-PA1-2S14-15")

#Execute the FP-growth C Implementation using the command line tool 
#developed by Borgelt in: http://www.borgelt.net//fpgrowth.html
#The following command is as follows:
#cmd /k fpgrowth.exe -tr basket.dat fpg.dat
#This command line produces the lhs, rhs, support, and confidence per association rule
FPG1 <- read.table("fpg.dat", sep = ",", col.names = c("rhs", "lhs", "support", "confidence"), header = FALSE, fill = TRUE)

#To obtain the lift, we run the FP-growth code again but with additional parameters
#The command is as follows:
#cmd /k fpgrowth.exe -tr -el -v,%el -s10 -c80 basket.dat fpg2.dat
FPG2 <- read.table("fpg2.dat", sep = ",", col.names = c("rhs", "lhs", "lift"), header = FALSE, fill = TRUE)

#Append lift
FPG <- cbind(FPG1, FPG2[3])
FPG <- as.data.frame.matrix(FPG)
index<- with(FPG, order(FPG$confidence, decreasing=TRUE))
FPG[index,]
#FPG[with(FPG, order(lift)),]
#FPG.sorted <- sort(FPG, by="lift")

