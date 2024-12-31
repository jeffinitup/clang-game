### music.gd
extends Node

## ModPlayer instance
var player : ModPlayer

func _ready() -> void:
	player = ModPlayer.new()
	player.bus = &"Music"
	player.name = "Player"
	player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(player)

func play_song_path(path : String, loop : bool = true) -> void:
	player.file = path
	player.loop = loop
	player.play()

func mute_channels(channels : Array[int]) -> void:
	for channel in channels:
		player.channel_status[channel].mute = true

func unmute_channels(channels : Array[int]) -> void:
	for channel in channels:
		player.channel_status[channel].mute = false
