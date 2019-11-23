set -e 

eval $(docker-machine env docker-eps)

RUTABASE=$PWD

#Clean workspace
rm -f docker-ms/*.jar

#Build
cd retobase-java
docker run -v //$PWD:/opt -v //$RUTABASE/mvncache:/root/.m2 maven:3.6.2-jdk-8 sh -c "cd /opt && mvn -DskipTests clean install"
cp target/*.jar ../docker-ms
docker run -v //$PWD:/opt -v //$RUTABASE/mvncache:/root/.m2 maven:3.6.2-jdk-8 sh -c "cd /opt && mvn clean"
cd ..

#Delivery
cd docker-ms
docker build -t test01:v01 .
cd ..

#Deployment
docker-compose down --remove-orphans
docker-compose up -d

#Test
sleep 10
DOCKERMCHIP=$(docker-machine ip docker-eps)
wget -q -O - http://$DOCKERMCHIP:3081/retoibm/sumar/80/300

#Monitoring
docker-compose ps

echo "Proceso Completo"
