#!/bin/sh
# ifconfig 에서 이더넷 이름 가져와 yaml 수정, /etc/netplan/*.yaml로 파일 이름 수정 추가 필요
ifconfig
sudo cp ./01-network-manager-all.yaml /etc/netplan/01-network-manager-all.yaml
sudo netplan apply