function Html-Generate {

  param(
    [string] $Title,
    [string] $Body,
    $File
  )

  ConvertTo-HTML -Body $Body -Title $Title | Out-File $File
}

function Get-Options {
  Write-Output 'Olá, digite o número equivalente a opção que deseja visualizar:'
    '1- Nome do Computador'
    '2- Principais serviços rodando'
    '3- Principais serviços parados'
    '4- Sistema Operacional'
    '5- BIOS'
    '6- Disk'
    '7- Memory'
    '8- Todos acima'

  $OPTION = read-host
  Write-Output 'Abra ou recarregue o arquivo HTML'  
  switch ( $OPTION )
  { #cada pção chama a função que converte para HTML a função correspondente
    1 { Get-HTML-Hostname   } 
    2 { 'Principais serviços rodando'   }
    3 { 'Principais serviços parados' }
    4 { 'Sistema Operacional'  }
    5 { 'BIOS'    }
    6 { Get-HTML-Infos }
    7 { 'Memory'  }
    8 { 'Todos'}
  }

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

  $OS = $OSinfo | Select-Object Name, Version, SerialNumber, RegisteredUser, BuildNumber, Caption, Manufacturer, InstallDate

  $OS
}

function Get-BIOS-Infos {
  $PCBIOS = Get-CimInstance -Classname WIN32_BIOS

  $BIOS = $PCBIOS | Select-Object Name, BIOSVersion, Version, SerialNumber, CurrentLanguage, STATUS
 
  $BIOS
}

function Get-Services-Info {

  $services = Get-Service | Where-Object { $_.Status -eq "Stopped" } | Select-Object -First 10

  $services
}

function Get-HTML-Hostname {
   $PCName = HOSTNAME
    Html-Generate -Body "<p>$PCName</p>" -Title "Avaliacao 3" -File ./SoAv3.html
}

function Get-HTML-Infos {
  $DiskInfo = Get-Disk-info

  
  Html-Generate -Body "
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

#Get-HTML-Infos
Get-Options