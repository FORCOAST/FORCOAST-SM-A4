#!/bin/bash
INITIAL_DIR="$(pwd)"
cd /usr/src/app
bash ./Extract_temperature.sh
bash ./Extract_water_velocity.sh