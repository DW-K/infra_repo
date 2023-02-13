# [string]$gpudevs = Read-host "put GPU instance path (device manager -> select GPU -> detail -> device instance path)"
$gpudevs = "PCI\VEN_10DE&DEV_1F95&SUBSYS_04101854&REV_A1\4&23B26ACC&0&0030"

#GPU 위치 경로 변수 선언 및 할당
# [string]$locationPath = Read-host "put GPU instance path (device manager -> select GPU -> detail -> location path)"
$locationPath = "PCIROOT(0)#PCI(0600)#PCI(0000)"


#VM에 연결된 PCI 장치 삭제

Remove-VMAssignableDevice -LocationPath $locationPath -VMName $vm

#PCI 장치를 호스트서버에 연결

Mount-VMHostAssignableDevice -LocationPath $locationPath

Enable-PnpDevice  -InstanceId $gpudevs

# PowerShell.exe -ExecutionPolicy Bypass -File retrieveGPU.ps1