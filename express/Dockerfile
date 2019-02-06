FROM node:alpine
MAINTAINER Jonathan Adams <myemail@gmail.com>

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ADD ./express /usr/src/app
ADD package.json /usr/src/app
ADD package-lock.json /usr/src/app

RUN npm install

EXPOSE 3000

CMD [ "node", "server" ]