#! /bin/bash
# docker image를 사용하여 jenkins를 사용하기위한 스크립트
# docker-compose 실행을 위한 환경 변수 및 폴더 생성
# ./docker-compose-run.sh build - jenkins 실행에 필요한 volume 및 .env파일 생성
# ./docker-compose-run.sh up - jenkins 실행
# ./docker-compose-run.sh down - jenkins 컨테이너 down
# ./docker-compose-run.sh remove - jenkins 컨테이너 /이미지/네트워크 /.env 삭제
#                                - volume용 directory는 삭제하지 않음

readonly JENKINS_HOME_DIR="/mnt/c/Users/pch14/workspace/jenkins/jenkins_volume"
readonly RUN_COMMAND=$1

#-------------- functions ---------------------------------------------

# https://stackoverflow.com/questions/3685970/check-if-a-bash-array-contains-a-value
containsElement () {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}

check_run_command() {
    local commands=("build" "up" "down" "remove")
    if ! containsElement "$RUN_COMMAND" "${commands[@]}" ; then
        echo "Please select run command(build/up/down/remove): ex) ./docker-compose-run.sh up"
        exit 1
    fi
}

create_dir() {    
    mkdir -p $JENKINS_HOME_DIR
    echo "----------------- Create directory -----------------"
    echo "jenkins_home volume: $JENKINS_HOME_DIR"
}

create_env() {
    echo "----------------- Create environment file: .env -----------------"
    cat >.env <<EOF
GID=$(id -g)
UID=$(id -u)
DOCKER_GROUP=$(stat -c '%g' /var/run/docker.sock)
VOLUME_JENKINS_HOME=$JENKINS_HOME_DIR
EOF

    # print .env file
    cat .env
}

execute_docker_compose() {
    echo "----------------- Execute docker-compose -----------------"
    if [ "$RUN_COMMAND" == "up" ]; then
        docker-compose -f docker-compose.yml up -d
    elif [ "$RUN_COMMAND" == "remove" ]; then
        docker-compose -f docker-compose.yml down --rmi all
        rm .env
    else 
        docker-compose -f docker-compose.yml "$RUN_COMMAND"
    fi

    echo "-----------------------------------------------"
    docker ps -f "name=my-jenkins"
    echo "-----------------------------------------------"
    docker images --filter=reference='my-jenkins'
}

execute_command() {    
    # env $(cat docker-compose.env) docker-compose -f docker-compose.yml -f docker-compose-build.yml up -d
    if [ "$RUN_COMMAND" == "build" ]; then
        create_dir
        create_env
    elif [ "$RUN_COMMAND" == "up" ]; then
        if [ ! -f ".env" ]; then
            echo "Please execute the build command before executing the up command"
            exit 1
        fi
    fi

    execute_docker_compose
}

#----------------------- start -------------------------------------
check_run_command
execute_command

# 실행 권한이 없는 경우 
# chmod u+x docker-compose-run.sh

# This may also be found at: /var/jenkins_home/secrets/initialAdminPassword
# docker logs -f my-jenkins