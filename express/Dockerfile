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

# docker build -t express-simple -f express/Dockerfile .
# docker run --rm --name express express-simple
# docker run --rm --name express -p 3000:3000 express-simple
# docker run --rm --name express -p 80:3000 express-simple