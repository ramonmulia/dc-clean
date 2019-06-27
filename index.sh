#!/bin/bash
arg=$1
arg2=$2
arg3=$3
path=""
execute_when_starts=""
remove_complete=0
aux_path=""
aux_execute=""

source config

store_config_file() {
    touch config
    echo "execute_when_starts=\"$execute_when_starts"\" >config
    echo "remove_type=\"$remove_type"\" >>config
}

exec_clean(){
    if [ "$arg" = "--all" ]; then        
     echo "Removing containers, images, volumes and pulling.."
     docker rm $(docker ps -qa)
     docker rmi $(docker images -qa)
     docker-compose -f "$path"/docker-compose.yml pull
     docker-compose -f "$path"/docker-compose.yml up -d
    else
        echo "Pruning.."
        docker system prune -f
    fi
}

run_script()
{
if [ "$arg" = "--help" ]; then
    echo -e "\n --all _path_:\tWill remove all docker containers, images, volumes and will pull new images"
    echo -e " --config:\tSet configurations\n" 
    exit
elif [ "$arg" = "--config" ]; then
    remove_type=0
    aux_execute=""
    while [ "$aux_execute" != "yes" -a "$aux_execute" != "y" -a "$aux_execute" != "n" -a "$aux_execute" != "no" ]; do
        read -p ' I want it executes when my computer starts (y/n): ' aux_execute
    done
    break_line=`echo $'\n '`
    while [ "$remove_type" != "1" -a "$remove_type" != "2" ]; do
        read -p "$break_line- Type (1) to remove completely all containers, images, volumes and pull using docker-compose file.$break_line- Type (2) to remove only unused images: $break_line" remove_type
    done
    execute_when_starts="$aux_execute"
    store_config_file
    exit
elif [ "$arg" = "--all" ]; then
    if [ "$arg2" = "" ]; then
        echo " missing docker compose path."
        exit
    fi
fi
}

run_script
exec_clean

