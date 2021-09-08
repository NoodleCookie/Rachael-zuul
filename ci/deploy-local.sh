#!/bin/sh

_project_name=$1
_project_version=$2
_port=$3

imageName=$_project_name:$_project_version

echo "imageName ====> $imageName"

containerId=`docker ps -a | grep -w ${_project_name}:${_project_version} | awk '{print $1}'`
containerId_2=`docker ps -a | grep -w $_project_name:$_project_version | awk '{print $1}'`
containerId_3=`docker ps -a | grep -w $_project_name:$_project_version | awk '{print $2}'`

echo "containerId ====> $containerId"
echo "containerId_2 ====> $containerId_2"
echo "containerId_3 ====> $containerId_3"

if [ "${containerId}" != "" ] ; then
	docker stop $containerId

	docker rm $containerId

	echo "rm container"
fi

docker run -d -p $_port:$_port $imageName

echo "deploy in local"