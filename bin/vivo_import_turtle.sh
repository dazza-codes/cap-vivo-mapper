#!/bin/bash

# Run this script from the cap-vivo-mapper app root, which should be installed under the user's home dir
# usage: USR=joe@stanford.edu PASSWD=secret ./bin/vivo_import_turtle.sh | tee -ai ./log/vivo_import_turtle.log

dtime=`date +%Y%m%d%H%S`

for f in /tmp/cap_vivo_rdf/*.ttl; do
  echo "update=LOAD <file://$f> into graph <https://sul-vitro-dev.stanford.edu/default/vitro-kb-2>" > tmp.sparql
  curl --insecure -d "email=$USR" -d "password=$PASSWD" -d '@tmp.sparql' https://sul-vivo-dev.stanford.edu/vivo/api/sparqlUpdate
done

rm tmp.sparql
mv ./log/vivo_import_turtle.log ./log/vivo_import_turtle.log.$dtime
