ARG PYTHON_VERSION=3.6.6-alpine3.8

FROM python:${PYTHON_VERSION} as builder

ENV PYTHONUNBUFFERED 1

# build time dependencies
RUN apk update && \
        apk add --no-cache \
        gcc \
        g++ \
        musl-dev

# build wheels instead of installing
WORKDIR /wheels

COPY requirements.txt .

RUN pip install -U pip && \
    pip wheel -r requirements.txt


FROM python:${PYTHON_VERSION}

# dependencies you need in your final image
RUN apk update && \
    apk add --no-cache \
        # good to have bash available
        bash \
        # locustio doesn't start without it
        libzmq

# copy built previously wheels archives
COPY --from=builder /wheels /wheels

COPY requirements.txt /wheels/requirements.txt

# use archives from /weels dir
RUN pip install -U pip \
       && pip install -r /wheels/requirements.txt -f /wheels \
       && rm -rf /wheels \
       && rm -rf /root/.cache/pip/*

# Expose locust web ui port
EXPOSE 8089

# Example locust file with simplest test
RUN mkdir locustio
WORKDIR locustio
COPY ./locustfile.py .

CMD ["locust","--host=http://localhost"]

# you can use it with:
# docker run -it -p 8089:8089 paterit/locustio-alpine
