FROM alpine:3.13 as build-stage

ENV FANTOM_NETWORK=opera
ENV GITHUB_BRANCH=release/1.1.1-rc.2
ENV GITHUB_URL=https://github.com/Fantom-foundation/go-${FANTOM_NETWORK}.git
ENV GITHUB_DIR=go-${FANTOM_NETWORK}

ENV GOROOT=/usr/lib/go 
ENV GOPATH=/go 
ENV PATH=$GOROOT/bin:$GOPATH/bin:/build:$PATH

RUN set -xe; \
  apk add --no-cache --virtual .build-deps \
  # get the build dependencies for go
  make gcc go musl-dev bash linux-headers git; \
  # install fantom client from github
  mkdir -p ${GOPATH}; cd ${GOPATH}; \
  git clone --single-branch --branch ${GITHUB_BRANCH} ${GITHUB_URL}; cd ${GITHUB_DIR}; \
  # build and copy the binary
  make -j$(nproc); mv build/${FANTOM_NETWORK} /usr/local/bin; \
  # remove our build dependencies
  rm -rf /go; apk del .build-deps; 

FROM alpine:latest as opera

RUN apk add --no-cache ca-certificates bash

ENV FANTOM_NETWORK=opera
ENV FANTOM_GENESIS=${FANTOM_GENESIS:-mainnet-109331-pruned-mpt.g}
ENV FANTOM_API=${FANTOM_API:-eth,ftm,net,web3,sfc}
ENV FANTOM_VERBOSITY=2
ENV FANTOM_CACHE=4096

# copy the binary 
COPY --from=build-stage /usr/local/bin/${FANTOM_NETWORK} /usr/local/bin/${FANTOM_NETWORK}

COPY run.sh /usr/local/bin
COPY entrypoint.sh /usr/local/bin
RUN chmod 755 /usr/local/bin/run.sh /usr/local/bin/entrypoint.sh /usr/local/bin/${FANTOM_NETWORK}

WORKDIR "/root/.${FANTOM_NETWORK}"

EXPOSE 5050 80 18546

VOLUME [ "/root"]

ENTRYPOINT [ "entrypoint.sh" ]
