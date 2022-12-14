#!/bin/bash

# check whther root folder was created
if [ ! -d db_root ]
then
	echo "Engine has not started please call start_engine.sh"
	exit 1
fi

