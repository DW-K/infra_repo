# Hyper-V에서 내부 ip고정 및 NAT/포트포워딩 방법.

## 1. make_vswitch.ps1 파일을 powershell 관리자 권한에서 실행
## 2. ubuntu ip 변경

### 1. /ubuntu/18.04/netplan/*.yaml 참조 하여 ubuntu 내부의 /etc/netplan/*.yaml 파일 수정
### 2. sudo netplan apply