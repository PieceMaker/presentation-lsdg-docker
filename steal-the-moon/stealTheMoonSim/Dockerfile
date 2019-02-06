FROM rminion:latest
MAINTAINER Jonathan Adams <jd.adams16@gmail.com>

ENV REDIS "127.0.0.1"

RUN apt-get update \
    && apt-get install -y \
        libgsl-dev

RUN mkdir -p /R
WORKDIR /R
COPY . /R

RUN r -e 'devtools::install()' \
    && chmod +x /R/runMinion.sh

CMD [ "./runMinion.sh" ]
