# Challenge 2 Demo Runner
# Run with: .\run-demo.ps1

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir

Write-Host ""
Write-Host "Starting Challenge 2 Demo..." -ForegroundColor Cyan
Write-Host ""

node quantum-heist.js --demo

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "Error: Make sure Node.js is installed and quantum-heist.js exists." -ForegroundColor Red
    exit 1
}
