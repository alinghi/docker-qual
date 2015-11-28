FROM ubuntu:14.04

ENV PG_VERSION 9.3

RUN sed -i 's/archive.ubuntu.com/ftp.kaist.ac.kr/g' /etc/apt/sources.list

# install packages
RUN apt-get update && apt-get install -y \
    curl \
    git \
    libpq-dev \
    nginx \
    postgresql-$PG_VERSION \
    python-dev \
    && apt-get clean

# install pip
RUN curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
RUN python /tmp/get-pip.py
RUN pip install --upgrade pip

# download app
RUN git clone https://github.com/protos37/qual /qual

# install python dependencies
RUN pip install -r /qual/requirements.txt

# Add app owner user
RUN useradd qual
RUN chown -R qual /qual

# setup PostgreSQL
WORKDIR /qual
RUN cp settings.py.default settings.py
RUN sudo -u postgres service postgresql start \
    && sudo -u postgres psql -c "CREATE USER qual;" \
    && sudo -u postgres psql -c "CREATE DATABASE qual;" \
    && sudo -u postgres psql -c "GRANT ALL privileges ON DATABASE qual TO qual;" \
    && sudo -u qual python /qual/manage.py db upgrade

# Link nginx to uwsgi
RUN pip install uwsgi
COPY uwsgi.ini /qual/uwsgi.ini
COPY qual.nginx /etc/nginx/sites-available/qual
RUN ln -s /etc/nginx/sites-available/qual /etc/nginx/sites-enabled/qual

EXPOSE 8888

