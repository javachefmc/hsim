# Handles global multiplayer operations

extends Node

const SERVER_PORT = 8080
const SERVER_IP = "127.0.0.1"

var player_scene = preload("res://scenes/player.tscn")
var _players_spawn_node

func host():
	print("Starting host")
	
	_players_spawn_node = Global.get_current_scene().get_node("Players")
	
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
	print("Player %s is joining" % id)
	var new_player : Player = player_scene.instantiate()
	new_player.player_id = id
	new_player.name = str(id)
	
	_players_spawn_node.add_child(new_player, true)

# Called when player disconnects from server
func _disconnect_player(id : int):
	print("Player %s is leaving" % id)
