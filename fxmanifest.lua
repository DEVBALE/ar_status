--[[ FX Information ]]--
fx_version 					'cerulean'
game 						'gta5'
lua54        				'yes'

--[[ Resource Information ]]--
name         'AR STATUS'
author       'ARROW DEVELOPER'
version      '1.0.0'
description  'STATUS'

--[[ Manifest ]]--
shared_scripts {
	'@ox_lib/init.lua',
	'config/config.general.lua',
}

client_scripts {
	'client/client.lua',
}

export 'OnAction'
export 'onStatus'