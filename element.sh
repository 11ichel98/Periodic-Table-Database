#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]; then
    CONDITION="atomic_number=$1"
  else
    CONDITION="symbol='$1' OR name='$1'"
  fi
  
  ELEMENT_DATA=$($PSQL "SELECT atomic_number, name, symbol FROM elements WHERE $CONDITION")

  if [[ -z $ELEMENT_DATA ]]; then
    echo "I could not find that element in the database."
  else
    IFS="|" read ATOMIC_NUMBER NAME SYMBOL <<< "$ELEMENT_DATA"
    PROPERTIES_DATA=$($PSQL "SELECT type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties JOIN types ON properties.type_id=types.type_id WHERE atomic_number=$ATOMIC_NUMBER")
    IFS="|" read TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS <<< "$PROPERTIES_DATA"
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  fi
fi
