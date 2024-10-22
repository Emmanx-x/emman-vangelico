-----------------For support, scripts, and more----------------
--------------- https://discord.gg/qBUx3y8v8u  -------------
---------------------------------------------------------------

fx_version 'cerulean'
game 'gta5'

author 'Emman Customize Script'
description 'Emman Vangelico Robbery Script'
version '1.0.0'

shared_script {
    '@qb-core/shared/locale.lua',
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/cl.lua',
    'locale/*.lua'
}

server_scripts {
    'server/**.lua'
}

lua54 'yes'
