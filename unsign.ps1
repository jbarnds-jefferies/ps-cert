[CmdletBinding()]

Param (
  [Parameter(Mandatory = $true)]
  [system.io.fileinfo] $path
)

Push-Location -Path $env:USERPROFILE
  
if (-Not $script.Extension -match '\.ps1|\.psm1|\.psd1|\.ps1xml') { 
  Write-Error -Message "File must be powershell script or module"
  Exit 1
}

try {
  $content =  Get-Content -Path $path.FullName -ErrorAction Stop
  $string_builder = New-Object -TypeName System.Text.StringBuilder -ErrorAction Stop
  ForEach ($line in $content) {
    if ($line -match '^# SIG # Begin signature block|^<!-- SIG # Begin signature block -->') {
      break
    }
    
    $null = $string_builder.AppendLine($line)
  }
  
  Set-Content -Path $path.FullName -Value $string_builder.ToString()
} catch {
  Pop-Location
  Write-Error -Message $path.Exception.Message
}
