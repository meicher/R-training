#returns probability of series of outcomes w/ same prob for each
seriesProb <- function(prob,num_events) return(prob^num_events)


plotprob <- function(probability,tot_events,color='blue',dot=16) {
  events_vec<- c(1:tot_events)
  prob_vec<-  probability
  #start vector w/ prob of 1 occurence -- so start for loop @ 2nd instance
  for (i in 2:tot_events){
    prob_vec <- append(prob_vec,seriesProb(probability,i))
  }
  #must create vector of events(1:n) for x axis
  #must create vector of probs
  plot(events_vec,prob_vec,pch=dot,col=color)
  lines(events_vec,prob_vec,col=color)
  return(seriesProb(probability,tot_events))
  #plot
  #add connecting line
  #return the final probability of the series of events
}


#plotprob(.954,30)
#NFL kicker making 30 PATs in a row - 24%


#--------Expected Value-----------#
#when prob is known, and loss, win outcomes are known - EV gives an idea of average value over large sample space

ExpValue<- function(investment,prob_lose,win_amt){
  prob_win <- abs(prob_lose - 1)
  return (((win_amt - investment)* prob_win) - (prob_lose * investment))
}

#ExpValue(1200,.935,20000)
#if my car insurance costs 1200 per year, and USE of the plan (in case of accident) = 20,000, chance of non-use is .935
#then my expected value is $100. What this tells us: to make a beneficial insurance plan - only need to know probability
#of accident for each individual. Perfect modelling problem.

#seriesProb(.5,4)


avg_var_std<- function(x) {
  return (c(mean(x),var(x),sd(x)))
}
#quick function to determine var,sd, mean
