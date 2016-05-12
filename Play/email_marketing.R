#Pull email results (daily deployments) from DBNAS02 server
#~700 files, equated to 5MM records
#de-duped by email and status, keeping the most recent date (3.4MM new count)

#next step: take the 3.41MM and combine with the other opens and clicks from Fatima

#Combine Open/Click Statuses: for now, let's see if we can predict either - either suggest inbox arrival
#Do I want to combine non-delivered statuses as well? Or exclude those emails that bounced?
#2 different problems:
#1: predict which emails are more likely to bounce
#2: predict which emails are more likely to be opened/clicked (and we know that bounces will not be opened)

