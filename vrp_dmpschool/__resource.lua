resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description "vRP dmpschool"

dependency "vrp"

client_scripts {
	"Proxy.lua",
	'plane_test_client.lua'
}

server_scripts {
	'@vrp/lib/utils.lua',
	'plane_test_server.lua'
}
