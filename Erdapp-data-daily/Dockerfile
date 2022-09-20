# "(C) Copyright FORCOAST H2020 project under Grant No. 870465. All rights reserved."

FROM osgeo/gdal

RUN mkdir -p /usr/src/app/ERDDAP_temp_hour/
RUN mkdir -p /usr/src/app/ERDDAP_temp_day_K/
RUN mkdir -p /usr/src/app/ERDDAP_temp_day_C/


RUN apt-get update
RUN apt-get install curl -y
RUN apt-get install zip -y
RUN apt-get install wget

COPY . /usr/src/app

ENTRYPOINT ["/usr/src/app/Extract_ERDDAP.sh"]