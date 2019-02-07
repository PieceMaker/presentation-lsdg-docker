#!/usr/bin/env bash
docker build -t credit-risk .
docker run -p 80:3838 --name credit-risk --rm credit-risk