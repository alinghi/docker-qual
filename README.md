# docker-qual

A docker container for [qual](https://github.com/protos37/qual)

### Application stack

* Nginx
* uwsgi
* Flask
* PostgreSQL

### Usage

```
docker build -t qual .
docker run -p 5000:8888 qual
```

Then connect to `yourdoma.in:5000` in your browser.

