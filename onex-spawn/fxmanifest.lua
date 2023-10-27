--  ██████╗ ███╗   ██╗███████╗██╗  ██╗    ███████╗ ██████╗██████╗ ██╗██████╗ ████████╗███████╗
-- ██╔═══██╗████╗  ██║██╔════╝╚██╗██╔╝    ██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝██╔════╝
-- ██║   ██║██╔██╗ ██║█████╗   ╚███╔╝     ███████╗██║     ██████╔╝██║██████╔╝   ██║   ███████╗
-- ██║   ██║██║╚██╗██║██╔══╝   ██╔██╗     ╚════██║██║     ██╔══██╗██║██╔═══╝    ██║   ╚════██║
-- ╚██████╔╝██║ ╚████║███████╗██╔╝ ██╗    ███████║╚██████╗██║  ██║██║██║        ██║   ███████║
--  ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝    ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝   ╚══════╝
                                                                                           
-- ===================== Official Information ================================================
name 'Onex Resource Module : Spawnmanager'
description 'Spawnmanager Script'
author 'Frostfire#3400'
PowerdBy 'Onex Scripts'
-- ====================== Game Configuration =================================================
fx_version 'cerulean'
game 'gta5'
version '0.1'
-- ====================  Resource UI  ========================================================
ui_page('ui/index.html')
files {'ui/index.html','ui/*','ui/assets/*.*','ui/fonts/*.ttf'} 
-- ==================== Resource Configuration ===============================================
client_scripts {
    'config/framework.lua',
    'config/settings.lua',
    'onNet.lua'
}
server_scripts {
    -- "@vrp/lib/utils.lua",  --- If you are using vrp uncomment this
    'onServerNet.lua'
}
escrow_ignore {'config/*.lua' , 'onServerNet.lua'}
-- ==================== Resource Code Configuration  =============================================
lua54 'yes'

dependency '/assetpacks'