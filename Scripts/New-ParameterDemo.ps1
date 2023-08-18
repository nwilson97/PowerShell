$dest = 'google.com'

function New-Ping {
    param (
        $Destination=($dest)
    )
    & ping $Destination
}
