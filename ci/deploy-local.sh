#!/bin/bash

_project_name=$1
_project_version=$2
_port=$3

imageName=$_project_name:$_project_version

echo "imageName ====> $imageName"

containerId=`docker ps -a | grep -w ${_project_name}:${_project_version} | awk '{print $1}'`

echo "containerId ====> $containerId"

if [ "${containerId}" != "" ] ; then
	docker stop $containerId

	docker rm $containerId

	echo "rm container"
fi

docker run -d -p $_port:$_port $imageName

echo "deploy in local"