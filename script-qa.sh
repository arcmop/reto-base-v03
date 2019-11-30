set -e 

eval $(docker-machine env docker-taller04)
export DOCKERMCHIP=$(docker-machine ip docker-taller04 || echo "127.0.0.1")

RUTABASE=$PWD

#Build
cd qa-automation
docker run -v //$PWD:/opt -v //$RUTABASE/mvncache:/root/.m2 maven:3.6.2-jdk-8 sh -c "cd /opt && mvn -DskipTests clean install"

#Functional Tests
mvn -Dtest=FunctionalTest01#test01 test
mvn -Dtest=FunctionalTest01#test02 test

cd ..


echo "Proceso Completo"
