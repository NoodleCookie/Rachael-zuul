#!/bin/bash

harbor_url=$1
harbor_project_name=$2
project_name=$3
tag=$4
port=$5

imageName=$harbor_url/$harbor_project_name/$project_name:$tag

echo "$imageName"

containerId=`docker ps -a | grep -w ${project_name}:${tag} | awk '{print $1}'`

if [ "${containerId}" != "" ] ; then
	docker stop $containerId

	docker rm $containerId

	docker container prune -f
fi

imageId=`docker images | grep -w $project_name | awk '{print $3}'`

if [ "${imageId}" != "" ] ; then

        docker rmi -f $imageId

	docker image prune -f

fi

docker login -u Izumi -p Qwer3936134 $harbor_url

docker pull $imageName

docker run -d -p $port:$port $imageName

echo "success deploy !"