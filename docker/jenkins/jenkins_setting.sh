# 1. docker 설치
# 2. docker 네트워크 생성
sudo docker network create jenkins

# 3. docker volumn create 명령어로 볼륨을 생성
# jenkins-docker-certs : Docker 데몬에 연결하는 데 필요한 Docker 클라이언트 TLS 인증서 공유

# jenkins-data : Jenkins 데이터 유지
sudo docker volume create jenkins-docker-certs
sudo docker volume create jenkins-data

