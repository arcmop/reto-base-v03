set -e 

eval $(docker-machine env docker-taller04)
DOCKERMCHIP=$(docker-machine ip docker-taller04 || echo "127.0.0.1")
RUTABASE=$PWD

#Test
URLTEST="http://${DOCKERMCHIP}:8089/retoibm/sumar/180/300"

echo "Test endpoint $URLTEST"
set +e
RETRYCOUNTER=10
while [ $RETRYCOUNTER -gt 0 ]
do
#wget -q -O - "${URLTEST}"
curl -Ss -X GET $URLTEST | jq
if [ $? -eq 0 ];then
   break
fi
RETRYCOUNTER=$[$RETRYCOUNTER-1]
sleep 10
done

echo "Proceso Completo"
