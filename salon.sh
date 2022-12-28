#! /bin/bash
PSQL="psql -X --username=postgres --dbname=salon -t --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~"
SERVICES() 
{
  echo -e "\nWelcome to My Salon, how can I help you?\n"
  SERVICE_MENU=$($PSQL "select service_id, name from services order by service_id")
 echo "$SERVICE_MENU" | while read SERVICE_ID BAR NAME
  do
  echo "$SERVICE_ID) $NAME"
  done
  #ask for service
  read SERVICE_ID_SELECTED
GET_SERVICE_ID=$($PSQL "select service_id from services where service_id=$SERVICE_ID_SELECTED")
#if service is not available
if [[ -z $GET_SERVICE_ID ]]
then
SERVICES "I could not find that service. What would you like today?"
else
#ask for phone number
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE
GET_CUSTOMER_PHONE=$($PSQL "select phone from customers where phone='$CUSTOMER_PHONE'")
#phone number is not available
if [[ -z $GET_CUSTOMER_PHONE ]]
then
echo -e "\nI don't have a record for that phone number, what's your name?"
read CUSTOMER_NAME
echo -e "\nWhat time would you like your cut, Fabio?"
read SERVICE_TIME
INSERT_CUSTOMER_NAME=$($PSQL "insert into customers(phone, name) values('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
#get customer id
CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
INSERT_SERVICE_TIME=$($PSQL "insert into appointments(customer_id, service_id, time) values($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
GET_SERVICE_NAME=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED")
echo -e "\nI have put you down for a$GET_SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
fi
fi 
}
SERVICES
