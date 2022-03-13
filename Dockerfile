FROM python:3.9-buster

WORKDIR /app
ENV PYTHONPATH="/app:$PYTHONPATH"
ENV JUMAN_FILE=juman-7.01
ENV JUMANPP_FILE=jumanpp-1.02
ENV KNP_FILE=knp-4.20

RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    build-essential \
    libboost-dev \
    mecab libmecab-dev mecab-ipadic mecab-ipadic-utf8 ipadic \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# juman
RUN wget https://nlp.ist.i.kyoto-u.ac.jp/nl-resource/juman/${JUMAN_FILE}.tar.bz2 && \
    tar -jxvf ${JUMAN_FILE}.tar.bz2 && \
    cd ${JUMAN_FILE}/ && \
    ./configure --prefix=/usr/local/ && \
    make && \
    make install

# juman++
RUN wget https://lotus.kuee.kyoto-u.ac.jp/nl-resource/jumanpp/${JUMANPP_FILE}.tar.xz && \
    tar Jxfv ${JUMANPP_FILE}.tar.xz && \
    cd ${JUMANPP_FILE}/ && \
    ./configure --prefix=/usr/local/ && \
    make && \
    make install

# knp
RUN wget https://nlp.ist.i.kyoto-u.ac.jp/nl-resource/knp/${KNP_FILE}.tar.bz2 && \
    tar -jxvf ${KNP_FILE}.tar.bz2 && \
    cd ${KNP_FILE}/ && \
    ./configure --prefix=/usr/local --with-juman-prefix=/usr/local && \
    make && \
    make install

# CaboCha
ENV CABOCHA_FILE=cabocha-0.69
RUN git clone --depth 1 https://github.com/taku910/crfpp.git ./tmp/crfpp && \
    cd ./tmp/crfpp && \
    sed -i '/#include "winmain.h"/d' crf_test.cpp && \
    sed -i '/#include "winmain.h"/d' crf_learn.cpp && \
    ./configure && \
    make && \
    make install && \
    ldconfig
ADD ./tmp/${CABOCHA_FILE}.tar.bz2 ./tmp
RUN cd ./tmp/${CABOCHA_FILE} && \
    ./configure --with-charset=utf8 --enable-utf8-only && \
    make && \
    make install

RUN ldconfig

RUN pip install poetry

COPY pyproject.toml ./
COPY poetry.lock ./
RUN poetry install

RUN cd ./tmp/${CABOCHA_FILE}/python && poetry run python setup.py install
