### player_weapon.gd
class_name PlayerWeapon extends Node2D

@onready var player := owner as Player

func update_rotation() -> void:
	look_at(get_global_mouse_position())
