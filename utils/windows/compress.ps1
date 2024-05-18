# Define the base, temporary, and archives directories
$BASE_DIR = ".\progs\gametypes"
$ARCHIVES_DIR = ".\archives"
$TEMP_DIR = ".\tmp"

# Create the archives directory if it doesn't exist
if (-not (Test-Path -Path $ARCHIVES_DIR)) {
    New-Item -ItemType Directory -Path $ARCHIVES_DIR | Out-Null
}

# Create the temporary directory if it doesn't exist
if (-not (Test-Path -Path $TEMP_DIR)) {
    New-Item -ItemType Directory -Path $TEMP_DIR | Out-Null
}

# Define the lock file path
$lockFilePath = "$TEMP_DIR\compress.lock"

# Check if the lock file already exists
if (Test-Path -Path $lockFilePath) {
    Write-Host "Compression script is already running. Exiting."
    exit
}

# Create the lock file
New-Item -ItemType File -Path $lockFilePath | Out-Null

# Loop through each directory within the base directory
Get-ChildItem -Directory -Path $BASE_DIR | ForEach-Object {
    $dir = $_.FullName
    $dirname = $_.Name

    # Define the temporary directory for this folder
    $temp_dir = "$TEMP_DIR\$dirname"

    # Create the temporary directory
    New-Item -ItemType Directory -Path $temp_dir -Force | Out-Null

    # Copy the contents to the temporary directory
    Copy-Item -Path "$dir\*" -Destination $temp_dir -Recurse

    # Define the output file name
    $output_file = "$ARCHIVES_DIR\$dirname.pk3"

    # Compress the contents of the temporary directory into a pk3 archive
    Compress-Archive -Path "$temp_dir\*" -DestinationPath $output_file -Force

    # Check if the compression was successful
    if (Test-Path -Path $output_file) {
        Write-Host "Successfully compressed $dir into $output_file"
    } else {
        Write-Host "Failed to compress $dir"
    }
}

# Remove the lock file
Remove-Item -Path $lockFilePath -Force

# Attempt to remove the temporary directory's parent directory
try {
    $parentDir = Split-Path -Path $TEMP_DIR -Parent
    Remove-Item -Path $parentDir -Recurse -Force -ErrorAction Stop
    Write-Host "Temporary directory removed successfully."
} catch {
    Write-Host "Failed to remove temporary directory and its parent: $_"
}
