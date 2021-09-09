#!/bin/sh

_project_name=$1
_project_version=$2

imageName=$_project_name:$_project_version
containerId=`docker ps -a | grep -w ${_project_name}:${_project_version} | awk '{print $1}'`

echo "======= clean container and image ======="

echo "imageName ====> $imageName"
echo "containerId ====> $containerId"

if [ "$containerId" != "" ] ; then

	docker rm -f $containerId

	echo "rm container"
fi

if [ "$imageName" != "" ] ; then

	docker rmi -f $imageName

	echo "rm image"
fi

echo "======= clean finish ======="