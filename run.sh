#!/bin/bash
# docker run forcoast-sm-a3 ...
INITIAL_DIR="$(pwd)"
cd /usr/src/app
python ./temp_oystergrounds_erddap_LB_WIP.py $1 $2 $3 $4 $5 $6 $7 $8 
python ./Bulletin/send_bulletin.py -A $1 -B $2 -C $3 -D $4 -E $5 -F $6 -G $7 -H $8 -I $9 -J ${10} -K ${11} -L ${12}

cp ./output/bulletin.png $INITIAL_DIR
