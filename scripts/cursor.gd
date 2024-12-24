### cursor.gd
class_name Cursor extends Node2D

const EXTENTS : float = 64.0

@onready var origin : Vector2 = position
var mouse_position : Vector2 = Vector2.ZERO
var last_vel : Vector2 = Vector2.ZERO

func _unhandled_input(event: InputEvent) -> void:
	if event is not InputEventMouseMotion:
		return
	
	owner = owner as Node2D
	event = event as InputEventMouseMotion
	
	var mouse_speed : Vector2 = event.screen_relative
	mouse_position += mouse_speed * 0.125
	mouse_position = mouse_position.limit_length(EXTENTS)
	position = origin + mouse_position
	
	last_vel = -owner.get_local_mouse_position().limit_length(EXTENTS)
