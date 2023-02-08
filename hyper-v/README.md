# Hyper-V에서 내부 ip고정 및 NAT/포트포워딩 방법.

## 1. make_vnet.ps1 파일을 powershell 관리자 권한에서 실행

# 반드시 1번만 실행
# 생성 확인 방법: ncpa.cpl
![image](https://user-images.githubusercontent.com/28096454/217505648-2145d3a4-c793-457f-a587-bd18648c5b0a.png)

## 2. 고정 IP 및 네트워크 설정하기
가상머신의 설정으로 들어가서 네트워크 어댑터의 가상스위치를 기본 Default Switch 에서 방금 생성한 NAT-Switch로 변경 후 부팅

## 3. ubuntu ip 변경

## 4. window에서 생성한 virtual network adapter ip 변경
![image](https://user-images.githubusercontent.com/28096454/217506233-30b63cf6-cd13-4c63-9dca-6b1332bf65fa.png)
![image](https://user-images.githubusercontent.com/28096454/217506302-228d01fc-649c-45ee-83d6-408916caf4f3.png)

## 5. 포트포워딩 (윈도우)
Add-NetNatStaticMapping -ExternalIPAddress "0.0.0.0/0" -ExternalPort 80 -Protocol TCP -InternalIPAddress "10.0.0.5" -InternalPort 80 -NatName NAT-Swtich

# ExternalPort와 InternalIPAddress, InternalPort 수정
