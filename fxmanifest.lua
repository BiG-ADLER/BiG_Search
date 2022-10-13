fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name "BiG Search System"
description "Advaced search system will be make all servers players can search eachother"
author "BiG ADLER#4557 {BiG Community}"
version "2.5.1"

shared_scripts {
	--'@es_extended/imports.lua',
	'@mysql-async/lib/MySQL.lua',
	'Shared/main.lua'
}

server_scripts {
	'Server/main.lua'
}

client_scripts {
	'Client/main.lua'
}