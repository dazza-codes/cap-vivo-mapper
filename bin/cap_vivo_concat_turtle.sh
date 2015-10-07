#!/bin/bash

rm -f data/vivo_rdf/all*.ttl
cat data/vivo_rdf/*.ttl | grep '@prefix' | sort -u > /tmp/vivo_rdf_prefixes.ttl
cat data/vivo_rdf/*.ttl | grep -v '@prefix' > /tmp/vivo_rdf_all_no_prefixes.ttl
cat /tmp/vivo_rdf_prefixes.ttl /tmp/vivo_rdf_all_no_prefixes.ttl > data/vivo_rdf/all.ttl
rm /tmp/vivo_rdf*.ttl
rapper -c -i turtle data/vivo_rdf/all.ttl
