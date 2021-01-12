## Setup NeoVim

setx XDG_CONFIG_HOME %USERPROFILE%\.config
setx XDG_DATA_HOME %USERPROFILE%\.config

Invoke-WebRequest -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
    New-Item "$(@($env:XDG_DATA_HOME, $env:LOCALAPPDATA)[$null -eq $env:XDG_DATA_HOME])/nvim/autoload/plug.vim" -Force

