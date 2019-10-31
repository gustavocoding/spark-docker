#!/bin/bash

set -e

usage() {
cat << EOF
  Usage: ./build-spark.sh -t TAG -s SCALA_VERSION
   -t Tag to build. E.g.: 2.4.4
   -s Scala major version to build. E.g. 2.12
   -h help
EOF
}

if [ $# -lt 3 ]
then
  usage
  exit 1
fi


while getopts ":s:t:h" o; do
    case "${o}" in
        h) usage; exit 0;;
        s)
            s=${OPTARG}
            ;;
        t)
            t=${OPTARG}
            ;;
        *)
            usage; exit 0;;
    esac
done
shift $((OPTIND-1))



TAG=${t}
SCALA_VERSION=${s}

[ ! -d "./spark" ] && git clone https://github.com/apache/spark.git
cd spark
git checkout v$TAG
export MAVEN_OPTS="-Xmx2g -XX:ReservedCodeCacheSize=512m"
./dev/change-scala-version.sh $SCALA_VERSION
./dev/make-distribution.sh --name custom-spark --pip --tgz -Psparkr -Pscala-$SCALA_VERSION -Phadoop-2.7 -Phive -Phive-thriftserver -Pmesos -Pyarn -Pkubernetes
cp spark-2.4.4-bin-custom-spark.tgz ../dist/spark.tgz

cd ..
IMAGE=gustavonalle/spark:${t}_${s}
docker build -t $IMAGE .
docker push $IMAGE
