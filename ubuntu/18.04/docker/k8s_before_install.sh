# 방화벽 해제
sudo ufw disable
# 허용 포트 목록
# # Master
# sudo ufw enable
# sudo ufw allow 6443/tcp
# sudo ufw allow 2379:2380/tcp
# sudo ufw allow 10250/tcp
# sudo ufw allow 10251/tcp
# sudo ufw allow 10252/tcp
# sudo ufw status

# # Worker
# sudo ufw enable
# sudo ufw allow 10250/tcp
# sudo ufw allow 30000:32767/tcp
# sudo ufw status

#----------------------------------------------------------------
# 보안그룹 설정(AWS)
# allow-kubernetes 라는 이름의 보안그룹을 생성합니다.
# protect-kubernetes 라는 이름의 보안그룹을 생성합니다.
# inbound 에 아래 내용을 설정합니다.

# 유형 : 모든 TCP
# 포트범위 : 0 – 65535
# 소스 : allow-kubernetes
# allow-kubernetes, protect-kubernetes 를 모든 master/node 에 할당해 줍니다.
