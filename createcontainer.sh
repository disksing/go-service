
#!/bin/bash
#docker����ϵͳ�����ű�

BASE_DIR=$0
echo $BASE_DIR

if [ -L $0 ]
then
    BASE_DIR=`dirname $(readlink $0)`
else
    BASE_DIR=`dirname $0`
fi

function createcontainer(){
    #echo "docker create --name "$1"DV -v "$3" centos:7.5.1804"
    #echo "(docker run --name "$1" --volumes-from "$1"DV -p "$2":22 dev_os:v2 /usr/sbin/sshd -D) &"
    #�˴������������������ڴ洢����������
    docker create --name "$1"DV -v /opt/dockerdata hello-world:latest
    #�˴�����ϵͳ���������ڿ����߿���ʹ��
    docker create --name "$1" --volumes-from "$1"DV -p "$2":22 -p "$3":8888 --security-opt seccomp=unconfined --privileged=true base_os:v3 /usr/sbin/init
    docker start $1
    docker cp $BASE_DIR/createuser.sh $1:/root
    docker exec -it $1 /bin/sh /root/createuser.sh $1
    echo "create root:root & "$1:$1" two accounts for container $1"
}

if [ $# != 3 ]
then
    echo "usage: createcontainer.sh [ContainerName] [SSHPort] [WorkPort]"
    exit 1
fi

stringname=$1
stringport=$2
stringWorkPort=$3
if [ $# == 3 ]
then
    createcontainer $stringname $stringport $stringWorkPort
fi