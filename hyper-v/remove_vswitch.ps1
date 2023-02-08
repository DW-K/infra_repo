$net = "NAT-Switch"
Remove-NetNatStaticMapping -NatName $net
echo "successfully remove NetNatStaticMapping"
Remove-NetNat -Name $net
echo "successfully remove NetNat"
Remove-NetIPAddress -InterfaceAlias "vEthernet (" + $net + ") "
2..100 | % {Remove-NetIPAddress -InterfaceAlias ("vEthernet ($net) " + $_)}
echo "successfully remove NetIPAddress"
Remove-VMSwitch -Name $net
echo "successfully remove VMSwitch"

# PowerShell.exe -ExecutionPolicy Bypass -File remove_vswitch.ps1