FROM ubuntu:focal AS builder

ARG version=2.1.27

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
       gcc \
       libgtk2.0-dev \
       libcfitsio-dev \
       libexpat1-dev \
       wcslib-dev

COPY ./cmunipack-${version}.tar.gz /tmp
WORKDIR /tmp
RUN tar xvf cmunipack-${version}.tar.gz && \
    cd cmunipack-${version} && \
    ./configure --disable-sound && \
    make && \
    make install

FROM ubuntu:focal

ARG version=2.1.27
LABEL version=${version}

RUN apt-get update && apt-get install -y \
       libgtk2.0-0 \
       libcfitsio8 \
       libexpat1 \
       wcslib-dev

COPY --from=builder /usr/local/lib /usr/local/lib
COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /usr/local/include /usr/local/include
COPY --from=builder /usr/local/share /usr/local/share

RUN ldconfig -v

RUN useradd --create-home --shell /bin/bash muniuser

USER muniuser
WORKDIR /home/muniuser
RUN mkdir data