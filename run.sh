#!/bin/bash
# docker run forcoast-sm-a3 ...
INITIAL_DIR="$(pwd)"
cd /usr/src/app
python ./temp_oystergrounds_erddap_LB_WIP.py $1 $2 $3 $4 $5 $6 $7 $8

