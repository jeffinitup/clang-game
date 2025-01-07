### music.gd
extends Node

## ModPlayer instance
var player : AudioStreamPlayer

func _enter_tree() -> void:
	player = AudioStreamPlayer.new()
	player.process_mode = Node.PROCESS_MODE_ALWAYS
	player.bus = &"Music"
	add_child(player)

func play_song_path(path : String, loop : bool = true) -> void:
	player.stream = load(path)
	player.play()

func mute_channels(channels : Array[int]) -> void:
	var mpt : AudioStreamPlaybackMPT = player.get_stream_playback()
	for channel in channels:
		mpt.set_channel_mute_status(channel, true)

func unmute_channels(channels : Array[int]) -> void:
	var mpt : AudioStreamPlaybackMPT = player.get_stream_playback()
	for channel in channels:
		mpt.set_channel_mute_status(channel, false)
