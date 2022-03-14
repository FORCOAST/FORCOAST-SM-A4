FROM python:3.10.2

RUN mkdir -p /Test-FORCOAST-SM-A4-main

COPY . /Test-FORCOAST-SM-A4-main

RUN apt-get update
RUN apt-get install -y python sqlite3 vim
RUN apt-get install -y python-setuptools python-dev build-essential python3-pip

RUN pip install xarray
RUN pip install requests
RUN pip install matplotlib
RUN pip install netCDF4
RUN pip install scipy

CMD ["python", "./Test-FORCOAST-SM-A4-main/temp_oystergrounds_erddap_LB_WIP.py"]