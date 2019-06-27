#!/bin/bash
arg=$1
arg2=$2
path=""
execute_when_starts=""
remove_complete=0
aux_path=""
aux_execute=""
remove_type=0

source config

store_config_file() {
    touch config
    echo "path=\"$aux_path"\" >config
    echo "execute_when_starts=\"$execute_when_starts"\" >>config
    echo "remove_type=\"$remove_type"\" >>config
}

if [ "$arg" = "--help" ]; then
    echo " --set: Set the docker-compose path"
elif [ "$arg" = "--set" ]; then
    if [ "$arg2" != "" ]; then
        path="$arg2"
    else
        echo " Missing path."
    fi
elif [ "$arg" = "--config" ]; then
    read -p ' Set docker_compose file path: ' aux_path
    path="$aux_path"
    while [ "$aux_execute" != "yes" -a "$aux_execute" != "y" -a "$aux_execute" != "n" -a "$aux_execute" != "no" ]; do
        read -p ' I want it executes when my computer starts (y/n): ' aux_execute
    done
    break_line=`echo $'\n '`
    while [ "$remove_type" != "1" -a "$remove_type" != "2" ]; do
        read -p "$break_line- Type (1) to remove completely all containers, images, volumes and pull using docker-compose file.$break_line- Type (2) to remove only unused images: $break_line" remove_type
    done
    execute_when_starts="$aux_execute"
    store_config_file
elif [ "$arg2" = "" ]; then
    echo " Missing path. dc-clean --help"
fi

if [ "$path" != "" ]; then
    echo "$path"
    #docker system prune - f
    #docker rm $(docker ps -qa)
    ##docker rmi $(docker images -qa)
    #"$path" docker-compose pull
    #"$path" docker-compose up -d
fi
