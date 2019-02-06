#!/usr/bin/bash
r -e "library(rminions); minionWorker(host = \"$REDIS\", logFileDir = \"stdout\");"
