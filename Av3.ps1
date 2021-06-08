function Html-Formate {

  param(
    [string] $Title,
    [string] $Body,
    $File
  )

  ConvertTo-HTML -Body $Body -Title $Title | Out-File $File
}

function Get-Disk-info {
  $DiskInfo = Get-Disk
  $diskSize = $DiskInfo[0].Size
  $diskNome = $DiskInfo[0].FriendlyName
  $diskStatus = $DiskInfo[0].OperationalStatus

  $Disk = "" | Select-Object Nome, Tamanho, Status
  $Disk.Nome = $diskNome
  $Disk.Tamanho = "${diskSize} MB"
  $Disk.Status = $diskStatus

  $Disk
}

function Get-OS-Infos {
  $OSinfo = Get-CimInstance -Classname Win32_OperatingSystem 

  $OS = $OSinfo | Select-Object Name, Version, SerialNumber, RegisteredUser, BuildNumber, Caption, BuildNumber, Manufacturer, InstallDate

  $OS
}

function Get-HTML-Infos {
  $PCName = HOSTNAME
  $DiskInfo = Get-Disk-info

  
  Html-Formate -Body "<p>$PCName</p>
  <table>
    <tr>
      <td>Nome</td>
      <td>Tamanho</td>
      <td>Status</td>
    </tr>
    <tr>
      <td>$($DiskInfo.Nome)</td>
      <td>$($DiskInfo.Tamanho)</td>
      <td>$($DiskInfo.Status)</td>
    </tr>
  </table>" -Title "Avaliacao 3" -File ./SoAv3.html
}

Get-HTML-Infos