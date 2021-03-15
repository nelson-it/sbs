#!/bin/bash

get_data()
{
    echo "$1" | sed -e "s@par1@$2@g" -e "s@par2@$3@g" -e "s@par3@$4@g" -e "s@par4@$5@g" | $psql --set ON_ERROR_STOP=on --tuples-only --no-align --field-separator '%%%%' -h $DBHOST -E  -U $DBUSER $DB 
}
