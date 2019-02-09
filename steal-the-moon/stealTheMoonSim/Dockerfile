FROM rminion:latest
MAINTAINER Jonathan Adams <myemail@gmail.com>

RUN apt-get update \
    && apt-get install -y \
        libgsl-dev

RUN mkdir -p /R
WORKDIR /R
COPY . /R

RUN r -e 'devtools::install()' \
    && chmod +x /R/runMinion.sh

ENV REDIS "redis"

CMD [ "./runMinion.sh" ]
