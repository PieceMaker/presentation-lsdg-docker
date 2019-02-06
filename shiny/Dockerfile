FROM rocker/shiny
MAINTAINER Jonathan Adams <myemail@gmail.com>

RUN mkdir -p /shiny
WORKDIR /shiny

RUN r -e "install.packages('DT')"

ADD app.R /shiny
ADD german_credit_data.csv /shiny
ADD runServer.sh /shiny

RUN chmod +x /shiny/runServer.sh

EXPOSE 3838

CMD [ "./runServer.sh" ]