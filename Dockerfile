FROM python:3.6.6-alpine3.8

RUN apk update && \
        apk add --no-cache \
        gcc \
        g++ \
        musl-dev

RUN pip install locustio

