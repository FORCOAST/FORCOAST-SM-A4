#!/bin/bash
# "(C) Copyright FORCOAST H2020 project under Grant No. 870465. All rights reserved."
INITIAL_DIR="$(pwd)"
cd /usr/src/app
bash ./Extract_temperature.sh
bash ./Extract_water_velocity.sh
