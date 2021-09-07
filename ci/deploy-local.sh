#!/bin/bash

_project_name=$1
_project_version=$2
_port=$3

imageName=$_project_name:$_project_version

echo "$imageName"

containerId=`docker ps -a | grep -w ${_project_name}:${_project_version} | awk '{print $1}'`

if [ "${containerId}" != "" ] ; then
	docker stop $containerId

	docker rm $containerId

	docker container prune -f

	echo "rm container"
fi

imageId=`docker images | grep -w $_project_name | awk '{print $3}'`

if [ "${imageId}" != "" ] ; then

        docker rmi -f $imageId

	      docker image prune -f

	      echo "rmi image"
fi

docker run -d -p $_port:$_port $imageName

echo "deploy in local"