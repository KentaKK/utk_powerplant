fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_experimental_fxv2_oal 'yes'

shared_script '@es_extended/imports.lua'


server_scripts {
    'server.lua',
    'config.lua'
}

client_scripts {
    'client/powerplant.lua',
    'config.lua'
}
