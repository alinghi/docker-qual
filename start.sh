#!/bin/sh
service postgresql start
service nginx restart
uwsgi --ini /qual/uwsgi.ini
