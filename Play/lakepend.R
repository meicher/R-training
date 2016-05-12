#https://lpo.dt.navy.mil
#lake pend oreille website


#Refactoring: Refactoring code must not change the external behavior of the code

#CRUD: Create read update delete

#R types of objects: S3,S4,Reference classes

library(lubridate)


GetPendOreille('20120723','20120724')

GetPendOreille<- function(startdate,enddate){
  start.date<- ymd(startdate) #ymd is a lubridate function
  end.date<-  ymd(enddate)
  if (start.date > end.date){
    stop('INVALID INPUT: Start date is after end date')
    
  }
  if (!exists('LakePendOreilleData')) source('LakePendOreilleData.R')
  
  LakePORData<- LakePendOreilleData()
  
  requestedYears<- as.character(c(year(star.date):year(end.date)))
  if(length(intersect(lakePORData$listAvailableYears(),requestedYears)) <1){
    stop('Sorry, Data not available')
  }
  
  if (end.date> now()){
    stop('End Date later than today')
  }
  
  por.weather.data<- lakePORData$getPORDataRange(start.date,end.date)
  
  Mean<- colMeans(por.weather.data[2:8],na.rm=TRUE)
  Median<- sapply(por.weather.data[2:8],median,na.rm=TRUE)
  rbind(Mean,Median)
  
  }

#otherfile-----------

LakePendOreilleData<- function(){
  kPORDeepMoorPath<- "https://lpo.dt.navy.mil/data/"
  
  checkURL<- file(kPORDeepMoorPath,'r')
  if (!isOpen(checkURL)){
    stop('theres a problem with the URL con',geterrmessage())
  }
  
  thisenv<- environment()
  
  yearsofdata<- data.frame(datetime = character(),
                           airtemp = numeric(),
                           baropress = numeric(),
                           dewpoint = numeric(),
                           relhumid = numeric(),
                           windir = numeric(),
                           windgust = numeric(),
                           windspeed = numeric())
  yearsofdata$datetime<- as.POSIXct(yearsofdata$datetime)
  this.yearsofdataalreadyloaded<- c('')
  #dont pull years twice
  
  availableyearsofdata<- c('2011','2012','2013','2014','2015')
  
  buildpathtodata<- function(year){
    paste(kPORDeepMoorPath,'DM/Environmental_Data_Deep_Moor_',year,'.txt')
  }
  
  this.loadayearofdata<- function(year){
    if(!is.element(year,this.yearsofdataalreadyloaded)){
      this.yearsofdataalreadyloaded <<- c(this.yearsofdataalreadyloaded,year)
      #double assign for global vars
      
    }
  }
                           
  
}
