#FROM tiangolo/uwsgi-nginx-flask:python3.7 # OBSOLETE because we switched to RQ
# See https://hub.docker.com/_/python/ for available packages
# FROM python:3.7-slim-stretch
# Brings in ConTeXt MkIV 2016.05
#   but Python 3.7 is not natively compatible with pickle protocol v8
#       see https://github.com/rq/rq/issues/1168
#FROM python:3.8-slim-buster
# Brings in ConTeXt MkIV 2018.04.04 which seems to have different syntax
FROM unfoldingword/obs-stretch-base:latest
# Brings in ConTeXt MkIV 2016.05
#   but has Python 3.8.1

# install packages, nodejs, and the OBS images
RUN apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get install -y apt-utils \
    && apt-get install -y \
        git \
        unzip \
        bzip2 \
        libfontconfig1 \
        curl \
        haskell-platform \
        build-essential \
        python3-setuptools \
        python3-wheel \
        python3-cffi \
        libcairo2 \
        libpango-1.0-0 \
        libpangocairo-1.0-0 \
        libgdk-pixbuf2.0-0 \
        libffi-dev \
        shared-mime-info \
        fonts-noto \
        wget \
        nano \
    && curl -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh \
    && chmod +x nodesource_setup.sh \
    && ./nodesource_setup.sh \
    && apt-get install -y nodejs \
    && mkdir -p /opt/pdf-converter/images/cdn.door43.org/obs/jpg \
    && mkdir -p /opt/pdf-converter/images/cdn.door43.org/obs/png \
    && curl -sL https://filedn.com/lD0GfuMvTstXgqaJfpLL87S/obs/jpg/obs-images-360px.zip -o /opt/pdf-converter/images/obs-images-360px.zip \
    && unzip /opt/pdf-converter/images/obs-images-360px.zip -d /opt/pdf-converter/images/cdn.door43.org/obs/jpg \
    && curl -sL https://cdn.door43.org/obs/png/uW_OBS_Logo.png -o /opt/pdf-converter/images/cdn.door43.org/obs/png/uW_OBS_Logo.png \
    && rm -v /opt/pdf-converter/images/obs-images-360px.zip
