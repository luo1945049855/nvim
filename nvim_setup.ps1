## Setup NeoVim

function Add-EnvVar {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Name,
        
        [Parameter(Mandatory = $true)]
        [string] $Value,
        
        [ValidateSet('Machine', 'User')]
        [string] $Container = 'User'
    )

    $containerMapping = @{
        Machine = [EnvironmentVariableTarget]::Machine
        User    = [EnvironmentVariableTarget]::User
    }
    $containerType = $containerMapping[$Container]
    
    $oldValue = [Environment]::GetEnvironmentVariable($Name, $containerType)
    if ($oldValue -ne $Value) {
        [Environment]::SetEnvironmentVariable($Name, $Value, $containerType)
    }
}

# https://gist.github.com/mkropat/c1226e0cc2ca941b23a9
#
function Add-EnvPath {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Path,

        [ValidateSet('Machine', 'User', 'Session')]
        [string] $Container = 'Session'
    )

    if ($Container -ne 'Session') {
        $containerMapping = @{
            Machine = [EnvironmentVariableTarget]::Machine
            User    = [EnvironmentVariableTarget]::User
        }
        $containerType = $containerMapping[$Container]

        $persistedPaths = [Environment]::GetEnvironmentVariable('Path', $containerType) -split ';'
        if ($persistedPaths -notcontains $Path) {
            $persistedPaths = $persistedPaths + $Path | Where-Object { $_ }
            [Environment]::SetEnvironmentVariable('Path', $persistedPaths -join ';', $containerType)
        }
    }

    $envPaths = $env:Path -split ';'
    if ($envPaths -notcontains $Path) {
        $envPaths = $envPaths + $Path | Where-Object { $_ }
        $env:Path = $envPaths -join ';'
    }
}

function Remove-EnvPath {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Path,

        [ValidateSet('Machine', 'User', 'Session')]
        [string] $Container = 'Session'
    )

    if ($Container -ne 'Session') {
        $containerMapping = @{
            Machine = [EnvironmentVariableTarget]::Machine
            User    = [EnvironmentVariableTarget]::User
        }
        $containerType = $containerMapping[$Container]

        $persistedPaths = [Environment]::GetEnvironmentVariable('Path', $containerType) -split ';'
        if ($persistedPaths -contains $Path) {
            $persistedPaths = $persistedPaths | Where-Object { $_ -and $_ -ne $Path }
            [Environment]::SetEnvironmentVariable('Path', $persistedPaths -join ';', $containerType)
        }
    }

    $envPaths = $env:Path -split ';'
    if ($envPaths -contains $Path) {
        $envPaths = $envPaths | Where-Object { $_ -and $_ -ne $Path }
        $env:Path = $envPaths -join ';'
    }
}

function ExtractZip {
    param(
        [string]$FilePath,
        [string]$Destination
    )
    # [System.IO.Compression.ZipFile]::ExtractToDirectory($FilePath, $Destination)
    
    $Shell = New-Object -ComObject shell.application
    $Zip = $Shell.Namespace($FilePath)
    foreach ($item in $Zip.items()) {
        $Shell.Namespace($Destination).CopyHere($item)
    }
}

Add-EnvVar "XDG_CONFIG_HOME" "$env:USERPROFILE\.config"
Add-EnvVar "XDG_DATA_HOME" "$env:USERPROFILE\.config"

Invoke-WebRequest -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
    New-Item "$(@($env:XDG_DATA_HOME, $env:LOCALAPPDATA)[$null -eq $env:XDG_DATA_HOME])/nvim/autoload/plug.vim" -Force
# Invoke-WebRequest -useb -Uri https://github.com/neovim/neovim/releases/download/nightly/nvim-win64.zip -Proxy http://127.0.0.1:10809 |`
# New-Item "$PSScriptRoot\nvim-win64.zip" -Force
# tar.exe -x "$PSScriptRoot\nvim-win64.zip" "$env:USERPROFILE\Neovim"
# Add-EnvPath "$env:USERPROFILE\Neovim" "User"

pause
