[string]$ip = Read-host "put vm internal ip address"
[string]$p1 = Read-host "put allow port range(start)"
[string]$p2 = Read-host "put allow port range(end)"

$arr = $ip.split(".")
$net = $arr[0..2] -join "."
$gateway = $net + ".1"
$prefix = $net + ".0/24"

New-VMSwitch -SwitchName "NAT-Switch" -SwitchType Internal
echo "successfully configure VM Switch"

New-NetIPAddress -IPAddress $gateway -PrefixLength 24 -InterfaceAlias "vEthernet (NAT-Switch)"
echo "successfully configure Net IP Address"

# ex) 10.0.0.1
New-NetNat -Name NAT-Switch -InternalIPInterfaceAddressPrefix $prefix
echo "successfully configure NetNat"

# Add-NetNatStaticMapping -ExternalIPAddress "0.0.0.0/0" -ExternalPort 10004 -Protocol TCP -InternalIPAddress "10.0.0.5" -InternalPort 80 -NatName NAT-Swtich

$p1..$p2 | % {Add-NetNatStaticMapping -ExternalIPAddress "0.0.0.0/24" -ExternalPort $_ -Protocol TCP -InternalIPAddress $ip -InternalPort $_ -NatName NAT-Switch }
echo "successfully configure NetNatStaticMapping"

Get-NetIPAddress
Get-VMSwitch
Get-NetNat
Get-NetNatStaticMapping

# PowerShell.exe -ExecutionPolicy Bypass -File make_vswitch.ps1