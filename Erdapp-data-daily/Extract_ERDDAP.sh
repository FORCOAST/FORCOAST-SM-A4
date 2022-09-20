#!/bin/bash
# "(C) Copyright FORCOAST H2020 project under Grant No. 870465. All rights reserved."
pwd='/usr/src/app'

#For 8760 hours in a year and thus the number of bands in .nc file
for i in {1..8760}
do
#Make 8670 individual tiff files
gdal_translate -b $i -a_srs EPSG:4326 "$pwd/NOS_HydroState_V1_2022.nc" "$pwd/ERDDAP_temp_hour/ERDDAP_temp_hour_b$i.tif"
echo $i

done

hour_tiffs="$pwd/ERDDAP_temp_hour/ERDDAP_temp_hour_b"
#Enter start year
let Year=2022
#Enter start day, 101 = 01-01 = 1st of January
let Day=101

#Loop through every day starting with hour 00:00
for i in {1..8760..24}
do

#If day goes over possible months day, go to next month
if [ "$Day" -eq 132 ]
then
let Day=201
elif [ "$Day" -eq 229 ]
then
let Day=301
elif [ "$Day" -eq 332 ]
then
let Day=401
elif [ "$Day" -eq 431 ]
then
let Day=501
elif [ "$Day" -eq 532 ]
then
let Day=601
elif [ "$Day" -eq 631 ]
then
let Day=701
elif [ "$Day" -eq 732 ]
then
let Day=801
elif [ "$Day" -eq 832 ]
then
let Day=901
elif [ "$Day" -eq 931 ]
then
let Day=1001
elif [ "$Day" -eq 1032 ]
then
let Day=1101
elif [ "$Day" -eq 1131 ]
then
let Day=1201
fi

#Define all hours of a day, so that $day$hour refers to a certain band/tiff file. Hour one is not defined as it is equal to $i
let Hour2=$i+1
let Hour3=$i+2
let Hour4=$i+3
let Hour5=$i+4
let Hour6=$i+5
let Hour7=$i+6
let Hour8=$i+7
let Hour9=$i+8
let Hour10=$i+9
let Hour11=$i+10
let Hour12=$i+11
let Hour13=$i+12
let Hour14=$i+13
let Hour15=$i+14
let Hour16=$i+15
let Hour17=$i+16
let Hour18=$i+17
let Hour19=$i+18
let Hour20=$i+19
let Hour21=$i+20
let Hour22=$i+21
let Hour23=$i+22
let Hour24=$i+23

#If the day is less than 1000 = before october => format the name differently
if [ "$Day" -lt 1000 ]
then
#Calculate daily average
gdal_calc.py -A $hour_tiffs$i.tif $hour_tiffs$Hour2.tif $hour_tiffs$Hour3.tif $hour_tiffs$Hour4.tif $hour_tiffs$Hour5.tif $hour_tiffs$Hour6.tif $hour_tiffs$Hour7.tif $hour_tiffs$Hour8.tif $hour_tiffs$Hour9.tif $hour_tiffs$Hour10.tif $hour_tiffs$Hour11.tif $hour_tiffs$Hour12.tif $hour_tiffs$Hour13.tif $hour_tiffs$Hour14.tif $hour_tiffs$Hour15.tif $hour_tiffs$Hour16.tif $hour_tiffs$Hour17.tif $hour_tiffs$Hour18.tif $hour_tiffs$Hour19.tif $hour_tiffs$Hour20.tif $hour_tiffs$Hour21.tif $hour_tiffs$Hour22.tif $hour_tiffs$Hour23.tif $hour_tiffs$Hour24.tif --outfile=$pwd/ERDDAP_temp_day_K/${Year}0${Day}T000000000Z.tif --calc="numpy.average(A,axis=0)"
#Convert Kelvin to Celsius
gdal_calc.py -A $pwd/ERDDAP_temp_day_K/${Year}0${Day}T000000000Z.tif --outfile=$pwd/ERDDAP_temp_day_C/${Year}0${Day}T000000000Z.tif --calc="A-273.15"

#If day is equal to start day => create new imagemosaic in geoserver (only use when there is no imagemosaic yet)
if [ "$Day" -eq 101 ] -a [ "$Year" -eq 2021 ]
then
#Zip tiff with timeregex and indexer
zip ${pwd}/init.zip -j $pwd/ERDDAP_temp_day_C/${Year}0${Day}T000000000Z.tif /usr/src/app/indexer.properties /usr/src/app/timeregex.properties
#Create imagemosaic
curl -v -u 'admin:#33f0rc0ast' -XPUT -H "Content-type: application/zip" -T ${pwd}/init.zip https://forecoast.apps.k.terrasigna.com/geoserver/rest/workspaces/test/coveragestores/surf_temp_daily_avg_north_sea_a4/file.imagemosaic
#Add timedimension
curl -v -u 'admin:#33f0rc0ast' -XPUT -H "Content-type:application/xml" -d "<coverage><enabled>true</enabled><metadata><entry key='time'><dimensionInfo><enabled>true</enabled><presentation>LIST</presentation><units>ISO8601</units><defaultValue/></dimensionInfo></entry></metadata></coverage>" https://forecoast.apps.k.terrasigna.com/geoserver/rest/workspaces/test/coveragestores/surf_temp_daily_avg_north_sea_a4/coverages/surf_temp_daily_avg_north_sea_a4 -k
else
#Zip only tiff
zip ${pwd}/add.zip -j $pwd/ERDDAP_temp_day_C/${Year}0${Day}T000000000Z.tif
#Add to imagemosaic
curl -u "admin:#33f0rc0ast" -XPOST -H "Content-type:application/zip" -T ${pwd}/add.zip https://forecoast.apps.k.terrasigna.com/geoserver/rest/workspaces/test/coveragestores/surf_temp_daily_avg_north_sea_a4/file.imagemosaic?recalculate=nativebbox.latlonbbox
#Remover zip file again, if not done, the file is not overwritten but extended
rm ${pwd}/add.zip
fi

#This else does the same as the if, but with a different name formatting
else
gdal_calc.py -A $hour_tiffs$i.tif $hour_tiffs$Hour2.tif $hour_tiffs$Hour3.tif $hour_tiffs$Hour4.tif $hour_tiffs$Hour5.tif $hour_tiffs$Hour6.tif $hour_tiffs$Hour7.tif $hour_tiffs$Hour8.tif $hour_tiffs$Hour9.tif $hour_tiffs$Hour10.tif $hour_tiffs$Hour11.tif $hour_tiffs$Hour12.tif $hour_tiffs$Hour13.tif $hour_tiffs$Hour14.tif $hour_tiffs$Hour15.tif $hour_tiffs$Hour16.tif $hour_tiffs$Hour17.tif $hour_tiffs$Hour18.tif $hour_tiffs$Hour19.tif $hour_tiffs$Hour20.tif $hour_tiffs$Hour21.tif $hour_tiffs$Hour22.tif $hour_tiffs$Hour23.tif $hour_tiffs$Hour24.tif --outfile=$pwd/ERDDAP_temp_day_K/$Year${Day}T000000000Z.tif --calc="numpy.average(A,axis=0)"
gdal_calc.py -A $pwd/ERDDAP_temp_day_K/$Year${Day}T000000000Z.tif --outfile=$pwd/ERDDAP_temp_day_C/$Year${Day}T000000000Z.tif --calc="A-273.15"

zip ${pwd}/add.zip -j $pwd/ERDDAP_temp_day_C/$Year${Day}T000000000Z.tif
curl -u "admin:#33f0rc0ast" -XPOST -H "Content-type:application/zip" -T ${pwd}/add.zip https://forecoast.apps.k.terrasigna.com/geoserver/rest/workspaces/test/coveragestores/surf_temp_daily_avg_north_sea_a4/file.imagemosaic?recalculate=nativebbox.latlonbbox
rm ${pwd}/add.zip
fi

#Add to day counter
let Day=$Day+1
done
