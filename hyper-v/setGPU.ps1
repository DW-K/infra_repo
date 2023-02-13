

#vm 이름 변수 선언 및 할당
# [string]$vm = Read-host "put vm name"
$vm = "ubuntu18"

#GPU 장치 인스턴스 경로 변수 선언 및 할당
# [string]$gpudevs = Read-host "put GPU instance path (device manager -> select GPU -> detail -> device instance path)"
$gpudevs = "PCI\VEN_10DE&DEV_1F95&SUBSYS_04101854&REV_A1\4&23B26ACC&0&0030"

#GPU 위치 경로 변수 선언 및 할당
# [string]$locationPath = Read-host "put GPU instance path (device manager -> select GPU -> detail -> location path)"
$locationPath = "PCIROOT(0)#PCI(0600)#PCI(0000)"

#VM 설정

#자동 중지 작업 설정(가상 컴퓨터 끄기 로 설정이 변경됩니다.)

Set-VM -Name $vm -AutomaticStopAction TurnOff

#CPU에 Write-Combining 설정
# GuestControlledCacheTypes는 가상 컴퓨터 게스트가 가상 디스크의 캐싱 동작을 제어할 수 있도록 하는 Microsoft Hyper-V의 기능입니다. 이 기능은 게스트 운영 체제에서 가상 디스크 작업에 사용할 디스크 캐시 유형을 선택할 수 있는 기능을 제공합니다.
Set-VM -GuestControlledCacheTypes $true -VMName $vm


#32 bit MMIO 공간 구성
# MMIO를 사용하면 가상 장치가 가상화 계층을 우회하여 호스트 시스템의 물리적 메모리와 직접 통신할 수 있습니다.
# 이 직접 통신은 가상화 계층을 통해 데이터를 전달할 필요가 없기 때문에 가상 장치와 호스트 간의 I/O 작업의 성능과 효율성을 크게 향상시킬 수 있습니다. MMIO는 가상 스토리지 컨트롤러, 가상 네트워크 어댑터, 가상 그래픽 장치 등 다양한 가상 장치에서 사용됩니다.
Set-VM -LowMemoryMappedIoSpace 3Gb -VMName $vm

#32 bit 이상 MMIO 공간 구성

Set-VM -HighMemoryMappedIoSpace 33280Mb -VMName $vm

# GPU
#호스트 서버에서 GPU 장치 사용 안 함 설정 (사용 안 함 설정이 되어있다면 무시 가능)

Disable-PnpDevice  -InstanceId $gpudevs

#호스트 서버에서 GPU 장치 분리

Dismount-VMHostAssignableDevice -force -LocationPath $locationPath

#VM에 GPU 장치 할당

Add-VMAssignableDevice -LocationPath $locationPath -VMName $vm

# PowerShell.exe -ExecutionPolicy Bypass -File setGPU.ps1
