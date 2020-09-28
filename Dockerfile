FROM alpine:latest

LABEL maintainer="yalex2011@gmail.com"
LABEL version="0.2"
LABEL description="Web2py docker image"

RUN apk add --no-cache python3 python3-dev && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    \
    apk add --no-cache unzip wget && \
    apk add --no-cache binutils libc-dev gcc libffi-dev openssl-dev && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    pip3 install --no-cache --upgrade gunicorn

RUN wget -c http://web2py.com/examples/static/web2py_src.zip && \
    unzip -o web2py_src.zip

COPY requirements.txt /requirements.txt

RUN pip3 install --no-cache --upgrade -r /requirements.txt

WORKDIR /web2py

EXPOSE 8000

CMD /usr/bin/python3 /web2py/anyserver.py -s gunicorn -i 0.0.0.0 -p 8000