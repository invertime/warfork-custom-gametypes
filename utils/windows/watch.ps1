# Define the folder to watch
$folderToWatch = ".\progs\gametypes"
$filter = "*.*"

# Flag to indicate if the compress script is currently running
$compressRunning = $false

# Define the action to take when a change is detected
$action = {
    Write-Host "Change detected in $($event.SourceEventArgs.FullPath)"
    if (-not $compressRunning) {
        $compressRunning = $true
        # Execute the compress script asynchronously
        Start-Job -ScriptBlock {
            .\utils\windows\compress.ps1
        }
    }
}

# Create a new FileSystemWatcher
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $folderToWatch
$watcher.Filter = $filter
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true

# Register events
Register-ObjectEvent $watcher "Changed" -Action $action
Register-ObjectEvent $watcher "Created" -Action $action
Register-ObjectEvent $watcher "Deleted" -Action $action
Register-ObjectEvent $watcher "Renamed" -Action $action

# Keep the script running
Write-Host "Watching for changes in $folderToWatch"
while ($true) {
    Start-Sleep -Seconds 1
}
