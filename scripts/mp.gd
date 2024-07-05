extends Node

const SERVER_PORT = 8080
const SERVER_IP = "127.0.0.1"

func host():
	print("Starting host")
	
	var server_peer = ENetMultiplayerPeer.new()
	server_peer.create_server(SERVER_PORT)
	
	multiplayer.multiplayer_peer = server_peer
	
	multiplayer.peer_connected.connect(_connect_player)
	multiplayer.peer_disconnected.connect(_disconnect_player)

func join_debug():
	print("Joining...")
	
	var client_peer = ENetMultiplayerPeer.new()
	client_peer.create_client(SERVER_IP, SERVER_PORT)
	
	multiplayer.multiplayer_peer = client_peer 

# Called when player connects to server
func _connect_player(id : int):
	print("Player %s has joined" % id)

# Called when player disconnects from server
func _disconnect_player(id : int):
	print("Player %s has left" % id)
