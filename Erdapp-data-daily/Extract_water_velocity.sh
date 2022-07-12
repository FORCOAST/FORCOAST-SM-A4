#!/bin/bash
pwd="/usr/src/app"

Year=$(date +"%Y")
Month=$(date +"%m")
Day=$(date +"%d")
Hour=$(date +"%H")

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

for variable in surface_baroclinic_eastward_sea_water_velocity surface_baroclinic_northward_sea_water_velocity
do
        mkdir -p "${pwd}/$variable"
        #Download the .nc file for the three days ahead with maximum extent
        wget -O "$pwd/$variable$Year$Month$Day.nc" "https://erddap.naturalsciences.be/erddap/griddap/NOS_HydroState_V1.nc?$variable[($Year-$Month-${Day}T00:00:00Z):1:($YearForecast3-$MonthForecast3-${DayForecast3}T23:00:00Z)][(48.5):1:(57)][(-4.0):1:(9)]"

        #Extract a tiff file from every band of the .nc file (for 24 hours)
        for i in {1..96}
        do
        HourSinceStart=$(( $i - 1 ))
        gdal_translate -b $i -a_srs EPSG:4326 "$pwd/$variable$Year$Month$Day.nc" "$pwd/$variable/$(date --date="$Year-$Month-$Day + $HourSinceStart hours" +"%Y%m%dT%H0000000Z").tif"
        done

        zip ${pwd}/add_$variable.zip -j $pwd/$variable/* 
        if [ $variable == "surface_baroclinic_eastward_sea_water_velocity" ]
        then 
            geoserverName="pilot_4_ERDAPP_east_v_v2"
        elif [ $variable == "surface_baroclinic_northward_sea_water_velocity" ]
        then 
            geoserverName="pilot_4_ERDAPP_north_v_v2"
        fi

        curl -u "admin:#33f0rc0ast" -XPOST -H "Content-type:application/zip" -T ${pwd}/add_$variable.zip https://forecoast.apps.k.terrasigna.com/geoserver/rest/workspaces/forcoast/coveragestores/$geoserverName/file.imagemosaic?recalculate=nativebbox.latlonbbox
        rm ${pwd}/add_$variable.zip

done
