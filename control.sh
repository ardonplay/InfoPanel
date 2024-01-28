#!/bin/bash

WORKDIR=$(pwd)
export GIT_TERMINAL_PROMPT=0

function usage() {
    cat <<USAGE

Usage:
    $0 [command] [options]

Commands:
    install      Install necessary components and repositories
    run          Run app
    stop         Stop app
    restart      Restart app
    help         Show usage information

Description:
    control - script that allows you to install infopanel app and run it.
    It can install the required components.

USAGE
    exit 1
}

function run_usage() {
    cat <<USAGE

Usage:
    $0 run [-d]

Options:
    d      Detached run. Run docker containers in detached mod.

USAGE
    exit 1
}

function add_usage() {
    cat <<USAGE

Usage:
    $0 add [-u]

Options:
    u      Install from remote repository

USAGE
    exit 1
}


# ==============================================
# COMPONENTS PREPARE (SC-machine SC-web ProblemSover)

# clone / pull any component
function prepare_component() {
    REPO=$1
    NAME=$2
    BRANCH=$3
    echo -e "\033[1m[$NAME]\033[0m":
    if [ -e "$NAME" ]; then
        cd $NAME   
        git pull
    else
        if [ "$BRANCH" ]; then 
            git clone --branch "$BRANCH" "$REPO" "$NAME"
        else 
        git clone "$REPO" "$NAME"
        fi
    fi
    cd $WORKDIR
}

# ==============================================
# UTILITIES 

# check if repo ever exist and clone
function clone_git_repo() {
    REPO=$1
    NAME=$2
    if git ls-remote --exit-code $REPO > /dev/null 2>&1; then
        # if repo exist - clone
        git clone --depth=1 "$REPO" "$NAME"
    else
        echo "Repo: [$REPO] not exist."
        exit 1
    fi
}


function prepare_interface() {
    if [ -e "client" ]; then
        cd client
        echo "[client][install]"
        npm i --silent
        echo "[client][build]"
        npm run build
    fi
    cd $WORKDIR
}

# ==============================================
# COMMAND SWITCHER

case $1 in

# clone components
install)   

        if [ $2 = '--dev' ]; then
            prepare_component git@github.com:ardonplay/infopanel-server server
            prepare_component git@github.com:ardonplay/infopanel-database database
            prepare_component git@github.com:ardonplay/infopanel-client client
        else
            prepare_component https://github.com/ardonplay/infopanel-server server
            prepare_component https://github.com/ardonplay/infopanel-database database
            prepare_component https://github.com/semantic-pie/infopanel-client client
        fi
        prepare_interface
    ;;


run)
    shift 1;
    while getopts "dh" opt; do
        case $opt in
        d) DETACHED=1 ;;
        h) run_usage  ;;
        \?) echo "Invalid option -$OPTARG" && run_usage
            exit 1
             ;;
        esac
    done
    shift $((OPTIND - 1))

    if [[ $DETACHED ]]; then
        echo "STARTING..."
        docker compose up -d
    else 
        docker compose up
    fi
    ;;

stop)
    shift 1;
    docker compose down 
    ;;

build)
    shift 1;
    docker compose build 
    ;;


restart)
    shift 1;
    docker compose down 
    prepare_all_kb
    docker compose up -d
    echo "[RESTARTED]"
    ;;
# show help
--help)
    usage
    ;;
help)
    usage
    ;;
-h)
    usage
    ;;

# All invalid commands will invoke usage page
*)
    usage
    ;;
esac
