[CmdletBinding()]

Param (
  [Parameter(Mandatory = $true)]
  [system.io.fileinfo] $path
)

Push-Location -Path $env:USERPROFILE

if (-Not $path.Extension -match '\.ps1|\.psm1|\.psd1|\.ps1xml') {
  Write-Error -Message "File must be powershell script or module"
  Exit 1
}


try {
  $full_path = Resolve-Path $path
  $content =  Get-Content -Path $full_path -ErrorAction Stop
  $string_builder = New-Object -TypeName System.Text.StringBuilder -ErrorAction Stop
  ForEach ($line in $content) {
    if ($line -match '^# SIG # Begin signature block|^<!-- SIG # Begin signature block -->') {
      break
    }

    $null = $string_builder.AppendLine($line)
  }

  Set-Content -Path $full_path -Value $string_builder.ToString()
} catch {
  Pop-Location
  Write-Error -Message $path.Exception.Message
}
