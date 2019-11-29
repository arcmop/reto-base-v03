set -e 

export PG_USER=pguser01
export PG_PWD=pgpassword
export PG_DB=pgdatabase

eval $(docker-machine env docker-eps)
DOCKERMCHIP=$(docker-machine ip docker-eps || echo "127.0.0.1")
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

sed "s/SERVER_TO_TEST/${DOCKERMCHIP}/g" ${RUTABASE}/frontend-ui/index_base.html > ${RUTABASE}/frontend-ui/index.html

#Deployment
docker-compose down --rmi local --remove-orphans
docker-compose build
docker-compose up -d

#docker-compose down --remove-orphans && docker-compose build && docker-compose up -d

#Test
URLTEST="http://${DOCKERMCHIP}:8089/retoibm/sumar/180/300"

echo "Test endpoint $URLTEST"
set +e
RETRYCOUNTER=5
while [ $RETRYCOUNTER -gt 0 ]
do
#wget -q -O - "${URLTEST}"
curl -Ss -X GET $URLTEST | jq
RETRYCOUNTER=$[$RETRYCOUNTER-1]
sleep 2
done

echo "End endpoint"

#Monitoring
docker-compose ps

echo "Proceso Completo"
