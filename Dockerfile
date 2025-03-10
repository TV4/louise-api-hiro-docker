FROM golang:alpine3.15
RUN apk update && \
    apk upgrade && \
    apk add git mercurial make g++ python2
# Build latest snowcrash separately, because the one inside drafter does not
# compile, so we will inject another version manually.
RUN cd && git clone --recursive https://github.com/apiaryio/snowcrash.git && \
    cd snowcrash && \
    ./configure && \
    make
RUN cd && git clone https://github.com/apiaryio/drafter.git && \
    cd drafter && \
    git checkout v3.2.7 && \
    git submodule init && \
    git submodule update --recursive && \
    rm -rf ext/snowcrash && \
    cp -r ../snowcrash ext/snowcrash && \
    ./configure && \
    make drafter && \
    make install
COPY ./iglo /go/src/github.com/subosito/iglo
RUN go install github.com/peterhellberg/hiro@latest
ENTRYPOINT ["tail", "-f", "/dev/null"]
