#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

$PSQL "TRUNCATE teams, games"
cat games.csv | while IFS="," read YEAR ROUND WIN OPP WIN_G OPP_G
do
  # this part is for teams table

  if [[ $WIN != 'winner' ]]
  then
    INSERT_WIN_TEAM_RES=$($PSQL "INSERT INTO teams(name) VALUES('$WIN') ON CONFLICT (name) DO NOTHING")
    if [[ $INSERT_WIN_TEAM_RES == 'INSERT 0 1' ]]
    then
      echo INSERTED $WIN
    else
      echo Team already exists
    fi

    INSERT_OPP_TEAM_RES=$($PSQL "INSERT INTO teams(name) VALUES('$OPP') ON CONFLICT (name) DO NOTHING")
    if [[ $INSERT_OPP_TEAM_RES == 'INSERT 0 1' ]]
    then
      echo INSERTED $OPP
    else
      echo Team already exists
    fi
  fi

  # This part is for games table

  if [[ $YEAR != year ]]
  then
    WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WIN'")
    OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPP'")
    INSERT_RES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WIN_ID, $OPP_ID, $WIN_G, $OPP_G)")
    echo INSERTED SUCCESSFULLY
  fi
done
