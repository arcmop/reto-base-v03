export PG_USER=pguser01
export PG_PWD=pgpassword
export PG_DB=pgdatabase

eval $(docker-machine env docker-taller04)
DOCKERMCHIP=$(docker-machine ip docker-taller04 || echo "127.0.0.1")
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
