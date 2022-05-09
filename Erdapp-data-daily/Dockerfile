FROM osgeo/gdal

RUN mkdir -p /usr/src/app/ERDAPP_temp_hour/
RUN mkdir -p /usr/src/app/ERDAPP_temp_day_K/
RUN mkdir -p /usr/src/app/ERDAPP_temp_day_C/


RUN apt-get update

COPY . /usr/src/app

ENTRYPOINT ["/usr/src/app/Extract_ERDAPP_daily.sh"]