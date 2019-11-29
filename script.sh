set -e 

export PG_USER=pguser01
export PG_PWD=pgpassword
export PG_DB=pgdatabase

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
docker-compose down --rmi local --remove-orphans
docker-compose build
docker-compose up -d

#docker-compose down --remove-orphans && docker-compose build && docker-compose up -d

#Test
sleep 20
set +e
echo "Extract IP"
DOCKERMCHIP=$(docker-machine ip docker-eps || echo "127.0.0.1")
URLTEST="http://${DOCKERMCHIP}:8089/retoibm/sumar/180/300"
echo "Test endpoint $URLTEST"
#wget -q -O - "${URLTEST}"
curl -Ss -X GET "${URLTEST}" | jq
echo ""

#Monitoring
docker-compose ps

echo "Proceso Completo"
