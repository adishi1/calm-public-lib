#name             "CreateVm"
#maintainer       "Calm.io"
#maintainer_email "ops.calm.io"
#description      "This script creates VM using existing vm in system center virtual machine manager"

#Input Args:
## VM_NAME
## VM_IMAGE
## CPU
## MEMORY
#Output Args
## HOST_IP

$vmmServerName = "localhost"
$vmName = "@@{VM_NAME}@@"
$HostName ="Demo02-$(Get-Random -Minimum 1 -Maximum 4).hyperv-systest.com"
$VMPath = "\\Unnamed\default-container-17627336789508"
$ScsiAdapterCount="1"
$cpuCount="@@{CPU}@@"
$reqRamSize="@@{MEMORY}@@"
$DVDDriveCount="1"
$networkAdapterCount = "1"
$Description = "This is $($vmName) Profile"
$vm_image="@@{VM_IMAGE}@@"
$VirtualNetwork="ExternalSwitch"
$VirtualNetworkId="d261cc95-fa89-45a0-8b5d-7c49363a0e1e"
$NoOfDisks = @@{NO_OF_DISKS}@@
$DiskSize = @@{DISK_SIZE}@@

Import-Module "C:\Program Files\Microsoft System Center 2012 R2\Virtual Machine Manager\bin\psModules\virtualmachinemanager\virtualmachinemanager.psd1"

$JobGroup = [System.Guid]::NewGuid()
$ProfileName = "Temp_$vmName"

if($vm_image -eq "windows2012r2"){
  $ImageName="WindowsServer2012R2-Base"
  $ImageId="2076f8c1-df03-499e-9d60-abd1770f25a2"
  $OperatingSystemType="Windows Server 2012 R2 Standard"
}

if (Get-SCVirtualMachine -VMMServer $vmmServerName -VMHost $HostName -Name $vmName)
{
 Write-Output "VM with name $vmName already exists on the Host $HostName.."
 Write-Output "Kindly provide different VM Name to proceed further.."
 exit
}
else
{
 Write-Output "Fetching the Host for $vmName.."
 $VMHost = get-SCVMHost -ComputerName $HostName
   if (!$VMHost )
   {
    Write-Output "HostName $HostName not found in VMM Server..Provide correct Host Name"
    exit
   }
 else
   {
     for($i=0 ; $i -lt $ScsiAdapterCount ;$i++)
   {
   Write-Output "Adding $i SCSI Adapter to HardwareProfile Template"
   New-SCVirtualScsiAdapter -VMMServer $vmmServerName -JobGroup $JobGroup -AdapterID 255 -ShareVirtualScsiAdapter $false -ScsiControllerType DefaultTypeNoType
   }

  for($j=0 ; $j -lt $DVDDriveCount ;$j++)
  {
   Write-Output "Adding $j DVD Drive to HardwareProfile Template"
   New-SCVirtualDVDDrive -VMMServer $vmmServerName -JobGroup $JobGroup -Bus 1 -LUN 0
  }
  Write-Output "Checking whether the HardwareProfile Exists or Not"

  if ( Get-SCHardwareProfile -VMMServer $vmmServerName | where { $_.Name -eq $ProfileName } )
  {
   Write-Output "HardwareProfile $ProfileName exists and proceeding to remove it"
   Get-SCHardwareProfile -VMMServer $vmmServerName | where { $_.Name -eq $ProfileName } | Remove-SCHardwareProfile | out-null
  }
  $VMNetwork = Get-SCVMNetwork -VMMServer $vmmServerName -Name "$VirtualNetwork" -ID $VirtualNetworkId
  if (!$VMNetwork){
  Write-Output "Vm Network not found"
  exit
  }

  New-SCVirtualNetworkAdapter -VMMServer $vmmServerName -JobGroup $JobGroup -MACAddressType Dynamic -VirtualNetwork $VirtualNetwork -VLanEnabled $false -Synthetic -EnableVMNetworkOptimization $false -EnableMACAddressSpoofing $false -EnableGuestIPNetworkVirtualizationUpdates $false -IPv4AddressType Dynamic -IPv6AddressType Dynamic -VMNetwork $VMNetwork
  $CPUType = Get-SCCPUType -VMMServer $vmmServerName | where {$_.Name -eq "3.60 GHz Xeon (2 MB L2 cache)"}

  Write-Output "Creating HardwareProfile Template creating for Static RAM"
  New-SCHardwareProfile -VMMServer $vmmServerName -CPUType $CPUType -Name $ProfileName -Description $Description -CPUCount $cpuCount -MemoryMB $reqRamSize -DynamicMemoryEnabled $false -MemoryWeight 5000 -VirtualVideoAdapterEnabled $false -CPUExpectedUtilizationPercent 20 -DiskIops 0 -CPUMaximumPercent 100 -CPUReserve 0 -NumaIsolationRequired $false -NetworkUtilizationMbps 0 -CPURelativeWeight 100 -HighlyAvailable $false -DRProtectionRequired $false -NumLock $false -BootOrder "CD", "IdeHardDrive", "PxeBoot", "Floppy" -CPULimitFunctionality $false -CPULimitForMigration $false -Generation 1 -JobGroup $JobGroup

  if("$NoOfDisks" -ge "1"){
    $count = 0
    ForEach ($HardDisk in (1..$NoOfDisks)){
      New-SCVirtualDiskDrive -VMMServer $vmmServerName -SCSI -Bus 0 -LUN $count -JobGroup $JobGroup -VirtualHardDiskSizeMB $DiskSize -CreateDiffDisk $false -Dynamic -Filename "$vmName-disk-$count" -VolumeType None
      $count++
    }
  }
  $Template = Get-SCVMTemplate -VMMServer $vmmServerName -ID $ImageId | where {$_.Name -eq $ImageName}
  if (!$Template){
  Write-Output "Vm Template not available"
  exit
  }
  $HardwareProfile = Get-SCHardwareProfile -VMMServer $vmmServerName | where {$_.Name -eq $ProfileName}
  $OperatingSystem = Get-SCOperatingSystem -VMMServer $vmmServerName -ID "50b66974-c64a-4a06-b05a-7e6610c579a2" | where {$_.Name -eq $OperatingSystemType}
  New-SCVMTemplate -Name "Temporary $JobGroup" -Template $Template -HardwareProfile $HardwareProfile -JobGroup $JobGroup -ComputerName "*" -TimeZone 4  -FullName "" -OrganizationName "" -Workgroup "WORKGROUP" -AnswerFile $null -OperatingSystem $OperatingSystem

  $template = Get-SCVMTemplate -All | where { $_.Name -eq "Temporary $JobGroup" }
  $virtualMachineConfiguration = New-SCVMConfiguration -VMTemplate $template -Name $vmName
  Write-Output $virtualMachineConfiguration
  Set-SCVMConfiguration -VMConfiguration $virtualMachineConfiguration -VMHost $vmHost
  Update-SCVMConfiguration -VMConfiguration $virtualMachineConfiguration

  $AllNICConfigurations = Get-SCVirtualNetworkAdapterConfiguration -VMConfiguration $virtualMachineConfiguration
  Update-SCVMConfiguration -VMConfiguration $virtualMachineConfiguration

  #while(Get-SCJob | where {$_.Status -eq "Running"} | where {$_.Name -ne "Refresh host cluster"}){
  # Write-Output "waiting for other process to complete"
  # sleep $(Get-Random -Minimum 1 -Maximum 10)
  #}
  Write-Output "Creating New VM $vmName on $VMHost"
  $NewVM = New-SCVirtualMachine -Name $vmName -VMConfiguration $virtualMachineConfiguration -Description "" -BlockDynamicOptimization $false -JobGroup $JobGroup -ReturnImmediately -StartAction AlwaysAutoTurnOnVM -StopAction "SaveVM" -StartVM

}
}
while($true){

    if((Get-SCVirtualMachine $VmName | select "Status" -ExpandProperty "Status") -eq "Running"){
        break
    }
    else{
        sleep 3
    }
}

Get-SCVMTemplate -All | where { $_.Name -eq "Temporary $JobGroup" } | Remove-SCVMTemplate -Force

Write-Output "Vm $($VmName) Running"

while($true){
    if((get-SCVirtualNetworkAdapter -VM $VmName -ErrorAction SilentlyContinue | select IPv4Addresses -ExpandProperty "IPv4Addresses") -eq $Null){
    Refresh-VM -VM $VmName
    sleep 3
    }
    else{
    $IP=get-SCVirtualNetworkAdapter -VM $VmName | select IPv4Addresses -ExpandProperty "IPv4Addresses"
    Write-Output "HOST_IP=$($IP)"
    break
    }
}
