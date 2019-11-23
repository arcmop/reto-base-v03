set -e 

eval $("C:\Program Files\Docker\Docker\Resources\bin\docker-machine.exe" env docker-master)

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
wget -q -O - http://192.168.99.100:3081/retoibm/sumar/80/300

#Monitoring
docker-compose ps

echo "Proceso Completo"