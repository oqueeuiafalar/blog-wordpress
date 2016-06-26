#!/bin/bash
RESTORE='\033[0m'
RED='\033[00;31m'
GREEN='\033[00;32m'
YELLOW='\033[00;33m'


# Pq ninguem merece ter que ficar decorando comando
# Instruções:
# 1) ". dev.sh"
# 2) "devhelp"
# 3) Seja feliz


export PROJ_BASE="$(dirname ${BASH_SOURCE[0]})"
CD=$(pwd)
cd $PROJ_BASE
export PROJ_BASE=$(pwd)
cd $CD

#. ci/funcs.sh

function devhelp {
    echo -e "${GREEN}devhelp${RESTORE}              Imprime este ${RED}help${RESTORE}"
    echo -e ""
    echo -e "${GREEN}build_docker_image${RESTORE}   Builda a imagem do docker"
    echo -e ""
    echo -e "${GREEN}run_docker_container${RESTORE} Executa o container docker"
    echo -e ""
}

function build_docker_image {
    dorun "docker build -t taciogt/wordpress:v1 ." "Cria a imagem do container para o blog"
}

function run_docker_container {
    dorun "docker stop blog_natalia" "Para o container anterior"
    dorun "docker rm blog_natalia" "Remove o container anterior"
    dorun "docker run -d --name blog_natalia -p 8002:80 -it taciogt/wordpress:v1" "Inicia o container do blog"
    echo_yellow "Agora o container está disponível aqui: http://0.0.0.0:8002/"
    echo_yellow "ou aqui: http://`docker-machine ip default`:8002/"
}

function attach_to_container_shell {
    dorun "docker exec -i -t blog_natalia bash" "Executa o bash do container"
}

function produce_alias {
    echo "------------------------------------------------------------------------"
    echo "Esse comando verdinho aih cria um alias que vc pode usar"
    echo "pra cair no ambdev deste projeto a partir de qualquer lugar do seu bash."
    echo "Sugestão: adiciona no seu ~/.bashrc"
    echo "Sugestão2: Muda o nome desse alias aih pra algo mais adequado"
    echo "------------------------------------------------------------------------"
    echo_green "alias dj3='cd $(readlink -e $PROJ_BASE) && . dev.sh'"
    echo "------------------------------------------------------------------------"
}

function echo_red {
    echo -e "${RED}$1${RESTORE}";
}

function echo_green {
    echo -e "${GREEN}$1${RESTORE}";
}

function echo_yellow {
    echo -e "${YELLOW}$1${RESTORE}";
}

function now_seconds {
    date +%s | cut -b1-13
}

function dorun {
    cmd="$1"
    name="$2"
    echo ----------------------------------
    echo_green "STARTING $name ..."
    echo "$cmd"
    t1=$(now_seconds)
    $cmd
    exitcode=$?
    t2=$(now_seconds)
    delta_t=$(expr $t2 - $t1)
    if [ $exitcode == 0 ]
    then
        echo_green "FINISHED $name in $delta_t s"
        echo ----------------------------------
    else
        echo_red "ERROR! $name (status: $exitcode, time: $delta_t s)"
        echo ----------------------------------
        return $exitcode
    fi
}

echo_green "Dica: autocomplete funciona pros comandos abaixo ;)"
echo_red   "------------------------------------------------------------------------"
devhelp
