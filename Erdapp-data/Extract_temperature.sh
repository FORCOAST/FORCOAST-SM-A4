#!/bin/bash
# "(C) Copyright FORCOAST H2020 project under Grant No. 870465. All rights reserved."
pwd="/usr/src/app"

Year=$(date +"%Y")
Month=$(date +"%m")
Day=$(date +"%d")

YearForecast1=$(date --date="1 days" +"%Y")
MonthForecast1=$(date --date="1 days" +"%m")
DayForecast1=$(date --date="1 days" +"%d")

YearForecast2=$(date --date="2 days" +"%Y")
MonthForecast2=$(date --date="2 days" +"%m")
DayForecast2=$(date --date="2 days" +"%d")

#Get the date for the three days ahead forecast
YearForecast3=$(date --date="3 days" +"%Y")
MonthForecast3=$(date --date="3 days" +"%m")
DayForecast3=$(date --date="3 days" +"%d")

#Download the .nc file for the three days ahead with maximum extent
wget -O "$pwd/Temp$Year$Month$Day.nc" "https://erddap.naturalsciences.be/erddap/griddap/NOS_HydroState_V1.nc?sea_surface_temperature[($Year-$Month-${Day}T00:00:00Z):1:($YearForecast3-$MonthForecast3-${DayForecast3}T23:00:00Z)][(48.5):1:(57)][(-4.0):1:(9)]"

#Extract a tiff file from every band of the .nc file (for 24 hours)
for i in {1..96}
do
gdal_translate -b $i -a_srs EPSG:4326 "$pwd/Temp$Year$Month$Day.nc" "$pwd/ERDAPP_temp_hour/ERDAPP_temp_hour_b$i.tif"
done

hour_tiffs="$pwd/ERDAPP_temp_hour/ERDAPP_temp_hour_b"

#Calculate daily average
gdal_calc.py -A ${hour_tiffs}1.tif ${hour_tiffs}2.tif ${hour_tiffs}3.tif ${hour_tiffs}4.tif ${hour_tiffs}5.tif ${hour_tiffs}6.tif ${hour_tiffs}7.tif ${hour_tiffs}8.tif ${hour_tiffs}9.tif ${hour_tiffs}10.tif ${hour_tiffs}11.tif ${hour_tiffs}12.tif ${hour_tiffs}13.tif ${hour_tiffs}14.tif ${hour_tiffs}15.tif ${hour_tiffs}16.tif ${hour_tiffs}17.tif ${hour_tiffs}18.tif ${hour_tiffs}19.tif ${hour_tiffs}20.tif ${hour_tiffs}21.tif ${hour_tiffs}22.tif ${hour_tiffs}23.tif  ${hour_tiffs}24.tif --outfile=$pwd/ERDAPP_temp_day_K/$Year$Month${Day}T000000000Z.tif --calc="numpy.average(A,axis=0)"
gdal_calc.py -A ${hour_tiffs}25.tif ${hour_tiffs}26.tif ${hour_tiffs}27.tif ${hour_tiffs}28.tif ${hour_tiffs}29.tif ${hour_tiffs}30.tif ${hour_tiffs}31.tif ${hour_tiffs}32.tif ${hour_tiffs}33.tif ${hour_tiffs}34.tif ${hour_tiffs}35.tif ${hour_tiffs}36.tif ${hour_tiffs}37.tif ${hour_tiffs}38.tif ${hour_tiffs}39.tif ${hour_tiffs}40.tif ${hour_tiffs}41.tif ${hour_tiffs}42.tif ${hour_tiffs}43.tif ${hour_tiffs}44.tif ${hour_tiffs}45.tif ${hour_tiffs}46.tif ${hour_tiffs}47.tif  ${hour_tiffs}48.tif --outfile=$pwd/ERDAPP_temp_day_K/$YearForecast1$MonthForecast1${DayForecast1}T000000000Z.tif --calc="numpy.average(A,axis=0)"
gdal_calc.py -A ${hour_tiffs}49.tif ${hour_tiffs}50.tif ${hour_tiffs}51.tif ${hour_tiffs}52.tif ${hour_tiffs}53.tif ${hour_tiffs}54.tif ${hour_tiffs}55.tif ${hour_tiffs}56.tif ${hour_tiffs}57.tif ${hour_tiffs}58.tif ${hour_tiffs}59.tif ${hour_tiffs}60.tif ${hour_tiffs}61.tif ${hour_tiffs}62.tif ${hour_tiffs}63.tif ${hour_tiffs}64.tif ${hour_tiffs}65.tif ${hour_tiffs}66.tif ${hour_tiffs}67.tif ${hour_tiffs}68.tif ${hour_tiffs}69.tif ${hour_tiffs}70.tif ${hour_tiffs}71.tif  ${hour_tiffs}72.tif --outfile=$pwd/ERDAPP_temp_day_K/$YearForecast2$MonthForecast2${DayForecast2}T000000000Z.tif --calc="numpy.average(A,axis=0)"
gdal_calc.py -A ${hour_tiffs}73.tif ${hour_tiffs}74.tif ${hour_tiffs}75.tif ${hour_tiffs}76.tif ${hour_tiffs}77.tif ${hour_tiffs}78.tif ${hour_tiffs}79.tif ${hour_tiffs}80.tif ${hour_tiffs}81.tif ${hour_tiffs}82.tif ${hour_tiffs}83.tif ${hour_tiffs}84.tif ${hour_tiffs}85.tif ${hour_tiffs}86.tif ${hour_tiffs}87.tif ${hour_tiffs}88.tif ${hour_tiffs}89.tif ${hour_tiffs}90.tif ${hour_tiffs}91.tif ${hour_tiffs}92.tif ${hour_tiffs}93.tif ${hour_tiffs}94.tif ${hour_tiffs}95.tif  ${hour_tiffs}96.tif --outfile=$pwd/ERDAPP_temp_day_K/$YearForecast3$MonthForecast3${DayForecast3}T000000000Z.tif --calc="numpy.average(A,axis=0)"
#Convert Kelvin to Celsius
gdal_calc.py -A $pwd/ERDAPP_temp_day_K/$Year$Month${Day}T000000000Z.tif --outfile=$pwd/ERDAPP_temp_day_C/$Year$Month${Day}T000000000Z.tif --calc="A-273.15"
gdal_calc.py -A $pwd/ERDAPP_temp_day_K/$YearForecast1$MonthForecast1${DayForecast1}T000000000Z.tif --outfile=$pwd/ERDAPP_temp_day_C/$YearForecast1$MonthForecast1${DayForecast1}T000000000Z.tif --calc="A-273.15"
gdal_calc.py -A $pwd/ERDAPP_temp_day_K/$YearForecast2$MonthForecast2${DayForecast2}T000000000Z.tif --outfile=$pwd/ERDAPP_temp_day_C/$YearForecast2$MonthForecast2${DayForecast2}T000000000Z.tif --calc="A-273.15"
gdal_calc.py -A $pwd/ERDAPP_temp_day_K/$YearForecast3$MonthForecast3${DayForecast3}T000000000Z.tif --outfile=$pwd/ERDAPP_temp_day_C/$YearForecast3$MonthForecast3${DayForecast3}T000000000Z.tif --calc="A-273.15"

#Zip tiff file and add to imagemosaic on geoserver
zip ${pwd}/add_temperature.zip -j $pwd/ERDAPP_temp_day_C/*
curl -u "admin:#33f0rc0ast" -XPOST -H "Content-type:application/zip" -T ${pwd}/add_temperature.zip https://forecoast.apps.k.terrasigna.com/geoserver/rest/workspaces/test/coveragestores/surf_temp_daily_avg_north_sea_a4/file.imagemosaic?recalculate=nativebbox.latlonbbox
rm ${pwd}/add_temperature.zip
