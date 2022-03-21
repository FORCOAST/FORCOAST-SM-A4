FROM python:3.10.2

RUN mkdir -p /usr/src/app
RUN mkdir -p /usr/src/app/output
RUN mkdir -p /usr/src/app/Bulletin

COPY . /usr/src/app
COPY ./Bulletin /usr/src/app/Bulletin

RUN apt-get update
RUN apt-get install -y python sqlite3 vim
RUN apt-get install -y python-setuptools python-dev build-essential python3-pip

RUN pip install xarray
RUN pip install requests
RUN pip install netCDF4
RUN pip install scipy
RUN pip install telepot
RUN pip install argparse
RUN pip install requests
RUN pip install df2img
RUN pip install ipython
RUN pip install nbformat
RUN pip install Pillow

RUN chmod 755 /usr/src/app/run.sh

ENTRYPOINT ["sh", "/usr/src/app/run.sh"]