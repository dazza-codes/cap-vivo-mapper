#!/bin/bash

usage () {
    cat <<HELP

$0 -u USER -p PASSWD -g GRAPH_URI -s SPARQL_URI -d DATA_PATH

-u USER        : user (email) for access to VIVO SPARQL_URI
-p PASSWD      : user password for access to VIVO SPARQL_URI
-g GRAPH_URI   : VIVO graph identifier, e.g.
                 https://{host}/default/vitro-kb-1
-s SPARQL_URI  : VIVO API for SPARQL Update, e.g.
                 https://{host}/vivo/api/sparqlUpdate
-d DATA_PATH   : Directory containing turtle data files (*.ttl)

HELP
}

# ---
# Parse the command line options

while getopts hu:p:g:s:d: opt; do
    case $opt in
    h)
        usage
        exit
        ;;
    u)
        EMAIL=$OPTARG
        ;;
    p)
        PASSWD=$OPTARG
        ;;
    g)
        GRAPH_URI=$OPTARG
        ;;
    s)
        SPARQL_URI=$OPTARG
        ;;
    d)
        DATA_PATH=$OPTARG
        ;;
    \?)
        echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
    :)
        echo "Option -$OPTARG requires an argument." >&2
        exit 1
        ;;
    esac
done

# ---
# Function to load a file into a graph using SPARQL update

sparql_update () {
    file=$1
    sparql="update=LOAD <file://${file}> into graph <${GRAPH_URI}>"
    curl --insecure -d "$sparql" -d "email=$EMAIL" -d "password=$PASSWD" ${SPARQL_URI}
}

#export TMP_SPARQL="/tmp/vivo_import_turtle_$$.sparql"

find ${DATA_PATH} -type f -name '*.ttl' -exec sparql_update {} \;

#rm $TMP_SPARQL
