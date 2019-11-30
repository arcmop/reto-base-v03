set -e 

export PG_USER=pguser01
export PG_PWD=pgpassword
export PG_DB=pgdatabase

eval $(docker-machine env docker-taller04)
DOCKERMCHIP=$(docker-machine ip docker-taller04 || echo "127.0.0.1")
RUTABASE=$PWD

#Deployment
docker stack rm tallereps
docker-compose -f docker-compose-swarm.yml build
docker stack deploy --compose-file=docker-compose-swarm.yml tallereps
docker service ls

echo "Proceso Completo"
