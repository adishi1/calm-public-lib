#name             "CreateVm"
#maintainer       "Calm.io"
#maintainer_email "ops.calm.io"
#description      "This script clone VM using existing vm in system center virtual machine manager"

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
$CPUType = Get-SCCPUType -VMMServer $vmmServerName | where {$_.Name -eq "3.60 GHz Xeon (2 MB L2 cache)"}
$VirtualNetwork="ExternalSwitch"
$VirtualNetworkId="d261cc95-fa89-45a0-8b5d-7c49363a0e1e"
$NoOfDisks = @@{NO_OF_DISKS}@@
$DiskSize = @@{DISK_SIZE}@@


Import-Module "C:\Program Files\Microsoft System Center 2012 R2\Virtual Machine Manager\bin\psModules\virtualmachinemanager\virtualmachinemanager.psd1"

$JobGroup = [System.Guid]::NewGuid()
$ProfileName = "Temp_$vmName"

if($vm_image -eq "centos7"){
  $ImageName="Centos7-Image"
  $ImageId="c53a17a5-a97c-4451-bd05-0007e7c8d1a3"
  $VMImageHost = "Demo02-2.hyperv-systest.com"
  $VirtualNetworkAdapter = Get-SCVirtualNetworkAdapter -VMMServer localhost -Name $ImageName -ID "c9934895-b5e2-4de0-a53d-48b229e63d79"
  $OperatingSystem = Get-SCOperatingSystem -VMMServer $vmmServerName -ID "a095d4f1-0d8d-4c17-882e-59cfe01cf55b" | where {$_.Name -eq "CentOS Linux 6 (64 bit)"}
}
else{
  Write-Output "Given Image Does not exists"
}


if (Get-SCVirtualMachine -VMMServer $vmmServerName -VMHost $HostName -Name $vmName)
{
 Write-Output "VM with name $vmName already exists on the Host $HostName.."
 Write-Output "Kindly provide different VM Name to proceed further.."
}
else
{
 Write-Output "Fetching the Host for $vmName.."
 $VMHost = get-SCVMHost -ComputerName $HostName
   if (!$VMHost )
   {
    Write-Output "HostName $HostName not found in VMM Server..Provide correct Host Name"
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
  $VMNetwork = Get-SCVMNetwork -VMMServer $vmmServerName -Name $VirtualNetwork  -ID $VirtualNetworkId
  if (!$VMNetwork){
  Write-Output "Vm Network not found"
  exit
  }

  Write-Output "Creating HardwareProfile Template creating for Static RAM"
  $HardwareProfile = New-SCHardwareProfile -VMMServer $vmmServerName -Name $ProfileName -Description $Description -DynamicMemoryEnabled $false -MemoryWeight 5000 -VirtualVideoAdapterEnabled $false -CPUExpectedUtilizationPercent 20 -DiskIops 0 -CPUMaximumPercent 100 -CPUReserve 0 -NumaIsolationRequired $false -NetworkUtilizationMbps 0 -CPURelativeWeight 100 -HighlyAvailable $false -DRProtectionRequired $false -NumLock $true -BootOrder "CD", "IdeHardDrive", "PxeBoot", "Floppy" -CPULimitFunctionality $false -CPULimitForMigration $false -JobGroup $JobGroup

  if("$NoOfDisks" -ge "1"){
    $count = 0
    ForEach ($HardDisk in (1..$NoOfDisks)){
      New-SCVirtualDiskDrive -VMMServer $vmmServerName -SCSI -Bus 0 -LUN $count -JobGroup $JobGroup -VirtualHardDiskSizeMB $DiskSize -CreateDiffDisk $false -Dynamic -Filename "$vmName-disk-$count" -VolumeType None
      $count++
    }
  }
  Set-SCVirtualNetworkAdapter -VirtualNetworkAdapter $VirtualNetworkAdapter -VMNetwork $VMNetwork -VLanEnabled $false -VirtualNetwork $VirtualNetwork -MACAddressType Dynamic -IPv4AddressType Dynamic -IPv6AddressType Dynamic -NoPortClassification -JobGroup $JobGroup

  $VM = Get-SCVirtualMachine -VMMServer localhost -Name $ImageName -ID $ImageId | where {$_.VMHost.Name -eq $VMImageHost}
  if (!$VM){
  Write-Output "Vm image not available"
  }
  sleep $(Get-Random -Minimum 1 -Maximum 30)

  while($true){
    try{
        while(Get-SCJob | where {$_.Status -eq "Running"} | where {$_.Name -ne "Refresh host cluster"}){
          Write-Output "waiting for other process to complete"
          sleep $(Get-Random -Minimum 1 -Maximum 10)
        }
    Write-Output "Creating New VM $vmName on $VMHost"
    $NewVM = New-SCVirtualMachine -VM $VM -Name $vmName -Description "" -JobGroup $JobGroup -UseDiffDiskOptimization  -VMHost $VMHost -Path $VMPath -HardwareProfile $HardwareProfile -OperatingSystem $OperatingSystem -StartAction AlwaysAutoTurnOnVM -DelayStartSeconds 0 -StopAction SaveVM -ErrorAction Stop
    }
    Catch{
        Write-Output "Error Occured: $($_.Exception.Message)"
    }
    if(Get-SCVirtualMachine -VMMServer $vmmServerName -VMHost $HostName -Name $vmName){
        Write-Output "VM Created"
        break
    }
    else{
        Write-Output "VM Creation failed retrying"
        continue
    }
  }
  Write-Output "Changing hardware properties"
  Set-SCVirtualMachine -VM $NewVM -Name $vmName -CPUCount $cpuCount -MemoryMB $reqRamSize -OperatingSystem $OperatingSystem -CPUType $CPUType
  Start-VM $vmName

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
