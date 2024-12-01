$env:FLUTTER_ROOT = "C:\flutter_3.22.3"
$env:PATH = "$env:FLUTTER_ROOT\bin;" + $env:PATH
Write-Output "Switched to Flutter 3.22.3"
flutter --version
