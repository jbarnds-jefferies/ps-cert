[CmdletBinding()]

Param (
  [Parameter(Mandatory = $true)]
  [system.io.fileinfo] $path
)

$cert = dir Cert:\CurrentUser\My\7E595AB6BADE0CF1096BBB9E17003755898A8986
$timestamp_server = "http://timestamp.digicert.com"
$full_path = Resolve-Path $path

Set-AuthenticodeSignature $full_path -Certificate $cert -TimestampServer $timestamp_server
