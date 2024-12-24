### player_spawn
@tool
class_name PlayerSpawn extends Marker2D

## Identifier for this spawn location
@export var id : int = 0

func _enter_tree() -> void:
	add_to_group("player_spawn")
