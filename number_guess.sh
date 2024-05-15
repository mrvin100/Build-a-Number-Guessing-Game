#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

RANDOM_NUMBER=$((RANDOM % (1000 - 0 + 1) + 0))
echo $RANDOM_NUMBER
NUMBER_OF_GUESSES=1

# echo $($PSQL "TRUNCATE games")

echo "Enter your username:"
# get username data
read USERNAME

GAME () {

# check if length name is lower than 22 characters

if [[ ${#USERNAME} -le 22 ]]
then
  IS_USED_USERNAME=$($PSQL "SELECT username FROM games WHERE username='$USERNAME' LIMIT 1")
  if [[ -z $IS_USED_USERNAME ]]
  then
    echo "Welcome, $USERNAME! It looks like this is your first time here."
  else
    GAMES_PLAYED=$($PSQL "SELECT COUNT(username) FROM games WHERE username='$USERNAME'")
    BEST_GAME=$($PSQL "SELECT MIN(number_of_guesses) FROM games WHERE username='$USERNAME'")
    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  fi
  START_GAME
  # insert games result of player
  INSERT_RESULT=$($PSQL "INSERT INTO games(username, number_of_guesses) VALUES('$USERNAME', $NUMBER_OF_GUESSES)")
fi
}

# function to generate number between 1 and 1000

START_GAME () {
  echo "Guess the secret number between 1 and 1000:"
  read INPUT
  # check if input is a valid number
  if [[ ! $INPUT =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
    (( NUMBER_OF_GUESSES++ ))
    START_GAME
  # check if input is equal to number
  elif [[ $INPUT -eq $RANDOM_NUMBER ]]
  then
    echo You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $RANDOM_NUMBER. Nice job\!
  else
    # check if input is lower than number
    if [[ $INPUT -lt $RANDOM_NUMBER ]]
    then
      echo "It's lower than that, guess again:"
      (( NUMBER_OF_GUESSES++ ))
      START_GAME
    fi
    # check if input is higher than number
    if [[ $INPUT -gt $RANDOM_NUMBER ]]
    then
      echo "It's higher than that, guess again:"
      (( NUMBER_OF_GUESSES++ ))
      START_GAME
    fi
  fi
}

GAME

# commit with fix:
# commit with feat:
# commit with refactor:
# commit with chore:
# commit with test: