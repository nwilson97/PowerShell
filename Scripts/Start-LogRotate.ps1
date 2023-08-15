Import-Module Log-Rotate

# Log-Rotate root path
$logRotatePath = "C:\Users\nicho\Documents\Log-Rotate"

# Define your config
# Double-quotes necessary only if there are spaces in the path
$config = "$logRotatePath\Log-Rotate.conf"

# Decide on a Log-Rotate state file that will be created by Log-Rotate
$state = "$logRotatePath\Log-Rotate.status"

# To check rotation logic without rotating files, use the -WhatIf switch (implies -Verbose)
#Log-Rotate -Config $config -State $state -WhatIf

# Full Command
Log-Rotate -Config $config -State $state -WarningAction SilentlyContinue
