set -e 

eval $(docker-machine env docker-eps)

RUTABASE=$PWD

#Build
cd qa-automation
docker run -v //$PWD:/opt -v //$RUTABASE/mvncache:/root/.m2 maven:3.6.2-jdk-8 sh -c "cd /opt && mvn -DskipTests clean install"

cd ..

echo "Proceso Completo"
