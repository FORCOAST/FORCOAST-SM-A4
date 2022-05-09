#!/bin/bash
pwd="/usr/src/app"

#Get the date for the three days ahead forecast
Year=$(date +"%Y")
Month=$(date +"%m")
Day=$(date --date="3 days" +"%d")

#Download the .nc file for the three days ahead with maximum extent
wget -O "$pwd/Temp$Year$Month$Day.nc" "https://erddap.naturalsciences.be/erddap/griddap/NOS_HydroState_V1.nc?sea_surface_temperature[($Year-$Month-${Day}T00:00:00Z):1:($Year-$Month-${Day}T23:00:00Z)][(48.5):1:(57)][(-4.0):1:(9)]"

#Extract a tiff file from every band of the .nc file (for 24 hours)
for i in {1..24}
do
gdal_translate -b $i -a_srs EPSG:4326 "$pwd/Temp$Year$Month$Day.nc" "$pwd/ERDAPP_temp_hour/ERDAPP_temp_hour_b$i.tif"
done

hour_tiffs="$pwd/ERDAPP_temp_hour/ERDAPP_temp_hour_b"

#Calculate daily average
gdal_calc.py -A ${hour_tiffs}1.tif ${hour_tiffs}2.tif ${hour_tiffs}3.tif ${hour_tiffs}4.tif ${hour_tiffs}5.tif ${hour_tiffs}6.tif ${hour_tiffs}7.tif ${hour_tiffs}8.tif ${hour_tiffs}9.tif ${hour_tiffs}10.tif ${hour_tiffs}11.tif ${hour_tiffs}12.tif ${hour_tiffs}13.tif ${hour_tiffs}14.tif ${hour_tiffs}15.tif ${hour_tiffs}16.tif ${hour_tiffs}17.tif ${hour_tiffs}18.tif ${hour_tiffs}19.tif ${hour_tiffs}20.tif ${hour_tiffs}21.tif ${hour_tiffs}22.tif ${hour_tiffs}23.tif  ${hour_tiffs}24.tif --outfile=$pwd/ERDAPP_temp_day_K/$Year$Month${Day}T000000000Z.tif --calc="numpy.average(A,axis=0)"
#Convert Kelvin to Celsius
gdal_calc.py -A $pwd/ERDAPP_temp_day_K/$Year$Month${Day}T000000000Z.tif --outfile=$pwd/ERDAPP_temp_day_C/$Year$Month${Day}T000000000Z.tif --calc="A-273.15"

#Zip tiff file and add to imagemosaic on geoserver
zip ${pwd}/add.zip -j $pwd/ERDAPP_temp_day_C/$Year$Month${Day}T000000000Z.tif
curl -u "admin:#33f0rc0ast" -XPOST -H "Content-type:application/zip" -T ${pwd}/add.zip https://forecoast.apps.k.terrasigna.com/geoserver/rest/workspaces/test/coveragestores/surf_temp_daily_avg_north_sea_a4/file.imagemosaic?recalculate=nativebbox.latlonbbox
rm ${pwd}/add.zip