### config.gd
extends Node

## Emitted when config changes
signal config_changed()

## Save path
const PATH := "user://"
const FILE := "config.fpd"

## Config data
var data : ConfigData = null

func _ready() -> void:
	data = ConfigData.new()

func load_config() -> void:
	data.deserialize()
	config_changed.emit()

func save_config() -> void:
	data.serialize()
	config_changed.emit()

func reset_config() -> void:
	OS.move_to_trash(ProjectSettings.globalize_path(PATH + FILE))
	data = ConfigData.new()

class ConfigData extends Resource:
	var version : int
	var vol_sound : float
	var vol_music : float
	
	func _init() -> void:
		if !self.has_file():
			# Init config
			print("Initializing config...")
			self.version = 1
			self.vol_sound = 1.0
			self.vol_music = 1.0
			
			# Save config
			self.serialize()
			return
			
		self.deserialize()
	
	func has_file() -> bool:
		return DirAccess.open(PATH).file_exists(FILE)
	
	func serialize() -> void:
		var file := FileAccess.open(PATH + FILE, FileAccess.WRITE)
		var stream := StreamPeerBuffer.new()
		
		stream.put_8(self.version)
		stream.put_float(self.vol_sound)
		stream.put_float(self.vol_music)
		
		file.store_buffer(stream.data_array)
		file.close()
	
	func deserialize() -> void:
		var file := FileAccess.open(PATH + FILE, FileAccess.READ)
		var stream := StreamPeerBuffer.new()
		
		stream.data_array = file.get_buffer(file.get_length())
		self.version = stream.get_8()
		self.vol_sound = stream.get_float()
		self.vol_music = stream.get_float()
		
		file.close()
