#!/bin/bash
# "(C) Copyright FORCOAST H2020 project under Grant No. 870465. All rights reserved."
# docker run forcoast-sm-a4 ...
INITIAL_DIR="$(pwd)"
cd /usr/src/app
python ./temp_oystergrounds_erddap_LB_WIP.py $1 $2 $3 $4 $5 $6 $7
python ./Bulletin/send_bulletin.py -A $1 -B $2 -C $3 -D $4 -E $5 -F $6 -G $7 -H $8 -I $9 -J ${10} -K ${11}

cp ${10} $INITIAL_DIR
