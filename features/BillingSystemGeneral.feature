As a user 
I can access a login-protected url of the site
I get redirected to login
And then I get sent to the original URL I was asking for


Subscription Rules

When a Payment Fails
If it was the first time the payment failed
the system sends the customer an email 
stating that the payment failed
and gives them a link to login (which redirects to the billing area)

If it was the second time the payment failed
The system send the customer a suspension warning email
and then sends them a suspension warning email every day

If it was the third time the payment failed
The system sends the customer a suspension email
And suspends the customer's web hosting account in WHM

If an account has been suspended for more than one month
The system sends the customer a warning email that files are going to be deleted
and then sends the customer the same warning email every day 

If an account has been suspended for 1.5 months
The system deletes the web hosting account from WHM

