# Load SSH signing key if not already loaded.
# --startup-hidden : from Startup (hidden)
# --interactive or no args : normal / visible

$startupHidden = $args -contains "--startup-hidden"
$interactive   = $args -contains "--interactive"

$scriptPath = $MyInvocation.MyCommand.Path
$keyPath    = Join-Path $env:USERPROFILE ".ssh\id_ed25519"

# Single-line comment marker, e.g.: your_email@example.com
$commentFile = Join-Path $PSScriptRoot "ssh_signing_key_comment.env"
$comment     = ""
if (Test-Path $commentFile) {
    $comment = (Get-Content $commentFile -Raw).Trim()
}

$keys = ssh-add -l 2>$null

if ($startupHidden) {
    if ($keys -match [regex]::Escape($comment)) {
        exit 0
    }

    Start-Process powershell.exe `
        -ArgumentList @(
            "-ExecutionPolicy", "Bypass",
            "-File", "`"$scriptPath`"",
            "--interactive"
        ) `
        -WindowStyle Normal

    exit 0
}

Write-Host "SSH agent status:"
if ($keys) {
    $keys | ForEach-Object { Write-Host "  $_" }
} else {
    Write-Host "  No keys are currently loaded in the SSH agent."
}

if ($keys -notmatch [regex]::Escape($comment)) {
    Write-Host "`nSigning key not detected. Loading key:"
    Write-Host "  $keyPath"
    ssh-add $keyPath
} else {
    Write-Host "`nSigning key is already loaded."
}

if (-not $startupHidden) {
    Write-Host "`nPress any key to close this window..."
    [void][System.Console]::ReadKey($true)
}
