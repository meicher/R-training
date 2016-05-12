valence<- read.csv(paste(getwd(),'/AFINN/AFINN-111.txt',sep = ''),stringsAsFactors = FALSE)
library(reshape)

new<- colsplit.character(valence[[1]],split='\t',names=c('word','valence'))

head(new)
