#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ Salon ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo "Welcome to My Salon, how can I help you?" 
  echo -e "\n1) cut\n2) color\n3) perm\n4) style\n5) trim\n6) exit the salon"
  
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) SERVICE="cut" BOOK_APPOINTMENT ;;
    2) SERVICE="color" BOOK_APPOINTMENT ;;
    3) SERVICE="perm" BOOK_APPOINTMENT ;;
    4) SERVICE="style" BOOK_APPOINTMENT ;;
    5) SERVICE="trim" BOOK_APPOINTMENT ;;
    6) QUIT ;;
    *) MAIN_MENU "Please enter a valid option." ;;
  esac
  
}

BOOK_APPOINTMENT() {
  echo -e "\nGreat, lets set up an appointment for a $SERVICE!\n"
  #echo $SERVICE which has the id of $SERVICE_ID_SELECTED


  #if number doesnt exist
  echo -e "\nWhat is your number?"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME ]]
    then
    # get new customer name
    echo -e "\nWhat's your name?"
    read CUSTOMER_NAME
    # insert new customer
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
    else
    echo -e "\nHello $CUSTOMER_NAME"
  fi

  CLIENT_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  # make a booking
  echo -e "\nWhen would you like your appointment?"
  read SERVICE_TIME

  CREATE_APPOINTMENT=$($PSQL "INSERT INTO appointments(service_id, customer_id, time) VALUES($SERVICE_ID_SELECTED, $CLIENT_ID,'$SERVICE_TIME')");
  echo -e "I have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
}

QUIT() {
  echo -e "\nThank you for stopping in.\n"
}

MAIN_MENU