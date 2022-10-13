#!/bin/bash

#(C) Copyright FORCOAST H2020 project under Grant No. 870465. All rights reserved.

# Copyright notice
# --------------------------------------------------------------------
#  Copyright 2022 Deltares
#   Gido Stoop
#
#   gido.stoop@deltares.nl
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#
#        http://www.apache.org/licenses/LICENSE-2.0
# --------------------------------------------------------------------

# docker run forcoast-sm-a4 ...
INITIAL_DIR="$(pwd)"
cd /usr/src/app
python ./temp_oystergrounds_erddap_LB_WIP.py $1 $2 $3 $4 $5 $6 $7
python ./Bulletin/send_bulletin.py -A $1 -B $2 -C $3 -D $4 -E $5 -F $6 -G $7 -H $8 -I $9 -J ${10} -K ${11}

cp ${10} $INITIAL_DIR
