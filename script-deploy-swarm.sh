set -e 

export PG_USER=pguser01
export PG_PWD=pgpassword
export PG_DB=pgdatabase

eval $(docker-machine env docker-taller04)
DOCKERMCHIP=$(docker-machine ip docker-taller04 || echo "127.0.0.1")
RUTABASE=$PWD

#Deployment
docker-compose down --remove-orphans
docker-compose build -f docker-compose-swarm.yml

echo "Proceso Completo"
