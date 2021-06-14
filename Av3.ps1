function Html-Generate {

  param(
    [string] $Title,
    [string] $Body,
    $File
  )

  ConvertTo-HTML -Body $Body -Title $Title | Out-File $File
}

function Get-Options {
  Write-Output 'Ola, digite o numero equivalente a opcao que deseja visualizar:'
  '1- Nome do Computador'
  '2- Principais servicos rodando'
  '3- Principais servicos parados'
  '4- Sistema Operacional'
  '5- BIOS'
  '6- Disk'
  '7- Todos acima'

  $OPTION = read-host
  Write-Output 'Abra ou recarregue o arquivo HTML'  
  switch ( $OPTION ) {
    #cada p��o chama a fun��o que converte para HTML a fun��o correspondente
    1 { Get-HTML-Hostname } 
    2 { Get-HTML-Services-Running }
    3 { Get-HTML-Services-Stopped }
    4 { Get-HTML-OSInfo }
    5 { Get-HTML-BIOSInfo }
    6 { Get-HTML-DiskInfo }
    7 { Get-All-Info }
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

function Get-HTML-DiskInfo {
  $DiskInfo = Get-Disk-info

  
  Html-Generate -Body "
  <h1>Disk</h1>
 
  <ul>
  <li>Nome: $($DiskInfo.Nome)</li>
  <li>Tamanho: $($DiskInfo.Tamanho)</li>
  <li>Status: $($DiskInfo.Status)</li>
  </ul>

  " -Title "Avaliacao 3" -File ./SoAv3.html
}

function Get-OS-Info {
  $OSinfo = Get-CimInstance -Classname Win32_OperatingSystem 

  $OS = $OSinfo | Select-Object Name, Version, SerialNumber, RegisteredUser, BuildNumber, Caption, Manufacturer, InstallDate

  $OS

}

function Get-HTML-OSInfo {

  $OS = Get-OS-Info
  
  Html-Generate -Body "
  <h1>Sistema Operacional</h1>
  <ul>
  <li>Name: $($OS.Name)</li>
  <li>Version: $($OS.Version)</li>
  <li>SerialNumber: $($OS.SerialNumber)</li>
  </ul>
  
  " -Title "Avaliacao 3" -File ./SoAv3.html
}



function Get-BIOS-Info {
  $PCBIOS = Get-CimInstance -Classname WIN32_BIOS

  $BIOS = $PCBIOS | Select-Object Name, BIOSVersion, Version, SerialNumber, CurrentLanguage, STATUS
 
  $BIOS
}

function Get-HTML-BIOSInfo {
  $BIOS = Get-BIOS-Info

  Html-Generate -Body "
 
  <h1>BIOS INFO</h1>
  <ul>
  <li>Name: $($BIOS.Name)</li>
  <li>BIOSVersion: $($BIOS.BIOSVersion)</li>
  <li>Version: $($BIOS.Version)</li>
  <li>SerialNumber: $($BIOS.SerialNumber)</li>
  <li>Status: $($BIOS.Status)</li>
  </ul>
  " -Title "Avaliacao 3" -File ./SoAv3.html
}

function Get-Services-Stopped {

  $services = Get-Service | Where-Object { $_.Status -eq "Stopped" } | Select-Object -First 10

  $services
}

function Get-HTML-Services-Stopped {
  $services = Get-Services-Stopped

  Html-Generate -Body "
  <h1>Principais serviços parados</h1>
  <ul>
  <li>Name: $($services.Name)</li>
  <li>Status: $($services.Status)</li>
  </ul>" -Title "Avaliacao 3" -File ./SoAv3.html
}

function Get-Services-Running {

  $services = Get-Service | Where-Object { $_.Status -eq "Running" } | Select-Object -First 10

  $services
}

function Get-HTML-Services-Running {
  $services = Get-Services-Running

  Html-Generate -Body "

  <h1>Principais serviços Rodando</h1>
  <ul>
  <li>Name: $($services.Name)</li>
  <li>Status: $($services.Status)</li>
  </ul>" -Title "Avaliacao 3" -File ./SoAv3.html
}

function Get-HTML-Hostname {
  $PCName = HOSTNAME
  Html-Generate -Body "<h1>Nome do Computador</h1><p>$PCName</p>" -Title "Avaliacao 3" -File ./SoAv3.html
}

function Get-All-Info {

  $DiskInfo = Get-Disk-info
  $OS = Get-OS-Info
  $BIOS = Get-BIOS-Info
  $servicesST = Get-Services-Stopped
  $servicesRN = Get-Services-Running
  $PCName = HOSTNAME

  Html-Generate -Body "
  <h1>Nome do Computador</h1>
  <p>$PCName</p>

  <h1>Disk</h1>
  <ul>
  <li>Nome: $($DiskInfo.Nome)</li>
  <li>Tamanho: $($DiskInfo.Tamanho)</li>
  <li>Status: $($DiskInfo.Status)</li>
  </ul>

  <h1>Sistema Operacional</h1>
  <ul>
  <li>Name: $($OS.Name)</li>
  <li>Version: $($OS.Version)</li>
  <li>SerialNumber: $($OS.SerialNumber)</li>
  </ul>
 
  <h1>BIOS</h1>
  <ul>
  <li>Name: $($BIOS.Name)</li>
  <li>BIOSVersion: $($BIOS.BIOSVersion)</li>
  <li>Version: $($BIOS.Version)</li>
  <li>SerialNumber: $($BIOS.SerialNumber)</li>
  <li>Status: $($BIOS.Status)</li>
  </ul>

  <h1>Principais servicos parados</h1>
  <table>
  <tr>
    <th>Name</th>
    <th>Status</th>
  </tr>
  <tr>
    <td>$($servicesST[0].Name)</td>
    <td>$($servicesST[0].Status)</td>
  </tr>
  <tr>
  <td>$($servicesST[1].Name)</td>
  <td>$($servicesST[1].Status)</td>
</tr>
<tr>
<td>$($servicesST[2].Name)</td>
<td>$($servicesST[2].Status)</td>
</tr>
<tr>
<td>$($servicesST[3].Name)</td>
<td>$($servicesST[3].Status)</td>
</tr>
<tr>
<td>$($servicesST[4].Name)</td>
<td>$($servicesST[4].Status)</td>
</tr>
<tr>
<td>$($servicesST[5].Name)</td>
<td>$($servicesST[5].Status)</td>
</tr>
<tr>
<td>$($servicesST[6].Name)</td>
<td>$($servicesST[6].Status)</td>
</tr>
<tr>
<td>$($servicesST[7].Name)</td>
<td>$($servicesST[7].Status)</td>
</tr>
<tr>
<td>$($servicesST[8].Name)</td>
<td>$($servicesST[8].Status)</td>
</tr>
<tr>
<td>$($servicesST[9].Name)</td>
<td>$($servicesST[9].Status)</td>
</tr>

  
</table>

  <h1>Principais servicos rodando</h1>
  <table>
  <tr>
    <th>Name</th>
    <th>Status</th>
  </tr>
  <tr>
    <td>$($servicesRN[0].Name)</td>
    <td>$($servicesRN[0].Status)</td>
  </tr>
  <tr>
  <td>$($servicesRN[1].Name)</td>
  <td>$($servicesRN[1].Status)</td>
</tr>
<tr>
<td>$($servicesRN[2].Name)</td>
<td>$($servicesRN[2].Status)</td>
</tr>
<tr>
<td>$($servicesRN[3].Name)</td>
<td>$($servicesRN[3].Status)</td>
</tr>
<tr>
<td>$($servicesRN[4].Name)</td>
<td>$($servicesRN[4].Status)</td>
</tr>
<tr>
<td>$($servicesRN[5].Name)</td>
<td>$($servicesRN[5].Status)</td>
</tr>
<tr>
<td>$($servicesRN[6].Name)</td>
<td>$($servicesRN[6].Status)</td>
</tr>
<tr>
<td>$($servicesRN[7].Name)</td>
<td>$($servicesRN[7].Status)</td>
</tr>
<tr>
<td>$($servicesRN[8].Name)</td>
<td>$($servicesRN[8].Status)</td>
</tr>
<tr>
<td>$($servicesRN[9].Name)</td>
<td>$($servicesRN[9].Status)</td>
</tr>

  
</table>
  
  "-Title "Avaliacao 3" -File ./SoAv3.html
 
}



#Get-HTML-Infos
Get-Options