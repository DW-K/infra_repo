# 공식 문서 : https://www.jenkins.io/doc/book/installing/
# 1. docker 설치
# 2. docker network create 명령어로 Docker에서 브릿지 네트워크 생성
sudo docker network create jenkins

# 3. docker volumn create 명령어로 볼륨을 생성
# jenkins-docker-certs : Docker 데몬에 연결하는 데 필요한 Docker 클라이언트 TLS 인증서 공유

# jenkins-data : Jenkins 데이터 유지
sudo docker volume create jenkins-docker-certs
sudo docker volume create jenkins-data

sudo docker container run \
  --network jenkins \
  --network-alias docker \
  --env DOCKER_TLS_CERTDIR=/certs \
  --volume jenkins-docker-certs:/certs/client \
  --volume jenkins-data:/var/jenkins_home \
  --volume ~/deploy:/var/jenkins_home/deploy \
