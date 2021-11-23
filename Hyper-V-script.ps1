#Settings
$QuantityVM = 2
$NameVM = "TestVM"
$NameVHDX = "Win10vPro.v1803_sysprep_(2).vhdx"
$VHDXTemplatePath = "h:\$NameVHDX"
$VHDXTargetPath = "H:\test\"
$Switchname = "vSwitch#1"
$Generation = 2
$RAM = 4096MB
$QuantityProcessorCores = 2

#Variables (do not change)
$Counter = 1

#VM creation with the settings
DO{     #LeadingNull
    if ($Counter -lt 10)
    {
      $CounterNull = "0" + $Counter
    }
    else
    {
      $CounterNull = $Counter
    }
    #VM creation 
    New-VM $NameVM$CounterNull -MemoryStartupBytes $RAM -SwitchName $Switchname -Generation $Generation
    #Set processor cores
    Set-VMProcessor $NameVM$CounterNull -Count $QuantityProcessorCores
    #Copy using VHDX 
    copy $VHDXTemplatePath $VHDXTargetPath #\$NameVM$CounterNull.vhdx
    #rename VHDX
    ren "$VHDXTargetPath$NameVHDX" "$NameVM$CounterNull.vhdx"
    #Attach VHDX to the VM
    Add-VMHardDiskDrive -VMName $NameVM$CounterNull -Path $VHDXTargetPath$NameVM$CounterNull.vhdx  
    #Change boat order
    Set-VMFirmware -VMname $NameVM$CounterNull -FirstBootDevice (Get-VMHardDiskDrive -VMName $NameVM$CounterNull)[0]
    #Set Auto Start to start
    Get-VM –VMname $NameVM$CounterNull | Set-VM –AutomaticStartAction Start
    #Set Auto Stop to shutdown
    Get-VM –VMname $NameVM$CounterNull | Set-VM –AutomaticStopAction  Shutdown
    #Increase variable counter
    $Counter = $Counter +1
  #Loop with condition Counter smaller than QuantityVM
} While ($Counter -le $QuantityVM)
