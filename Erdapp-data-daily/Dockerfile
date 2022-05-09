FROM osgeo/gdal

RUN mkdir -p /usr/src/app/ERDAPP_temp_hour/
RUN mkdir -p /usr/src/app/ERDAPP_temp_day_K/
RUN mkdir -p /usr/src/app/ERDAPP_temp_day_C/

RUN apt-get install curl -y
RUN apt-get install zip -y
RUN apt-get install wget


RUN apt-get update

COPY . /usr/src/app

ENTRYPOINT ["/usr/src/app/Extract_ERDAPP_daily.sh"]
