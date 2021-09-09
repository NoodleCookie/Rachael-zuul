     1	#!/bin/bash
     2
     3	_project_name=$1
     4	_project_version=$2
     5	_port=$3
     6
     7
     8	echo "==== deploy start ===="
     9
    10	imageName=$_project_name:$_project_version
    11
    12	echo "imageName ==> $imageName"
    13
    14	docker run -d -p $_port:$_port $imageName
    15
    16	echo "==== deploy finish ===="