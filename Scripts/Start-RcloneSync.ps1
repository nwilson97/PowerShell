$executable = 'rclone.exe'
$command = 'sync'
$config = '"C:\Users\nicho\AppData\Roaming\rclone\rclone.conf"'
$log = '"C:\Users\nicho\Documents\Rclone\sync.log"'
#$appendLog = $log.Replace('"','')
$source = '"E:\Macrium Reflect"'
$destination = 'b2reflect:reflect86032813'
$flags = @(
    "--config=$config"
    #'--exclude=/Data/**'
    '--max-depth=2'
    '--fast-list'
    '--checkers=16'
    '--track-renames'
    #'--ignore-checksum'
    '--retries=6'
    '--transfers=32'
    #'--b2-chunk-size=1G'
    '--no-console'
    "--log-file=$log"
    '--log-level=INFO'
    #'--dry-run'
)
$arguments = @(
    $command
    $source
    $destination
    $flags
)

function Write-Log {
    param (
        [string]$String
    )
    Write-Output "$(Get-Date -Format 'yyyy/MM/dd HH:mm:ss') INFO  : $String" | Out-File -FilePath $log.Replace('"', '') -Append
}


if ( ! ( Get-Process -Name 'rclone' -ErrorAction SilentlyContinue ) ) {
    $process = Start-Process -FilePath $executable -ArgumentList $arguments -PassThru -NoNewWindow -Wait
}
else {
    while ( Get-Process -Name 'rclone' -ErrorAction SilentlyContinue ) {
        Write-Log -String 'Rclone is already running. Next attempt in 5 minutes.'
        Start-Sleep -Seconds 300
    }    
}
$exitCode = $process.ExitCode
Write-Log -String "Rclone exited with code: $exitCode"
