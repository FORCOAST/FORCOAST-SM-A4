FROM osgeo/gdal

RUN mkdir -p /usr/src/app/ERDAPP_temp_hour/
RUN mkdir -p /usr/src/app/ERDAPP_temp_day_K/
RUN mkdir -p /usr/src/app/ERDAPP_temp_day_C/

RUN apt-get update

RUN apt-get install curl -y
RUN apt-get install zip -y
RUN apt-get install wget

COPY Extract_temperature.sh Extract_water_velocity.sh run.sh /usr/src/app

ENTRYPOINT ["/usr/src/app/run.sh"]
