### cursor.gd
class_name Cursor extends Node2D

const EXTENTS : float = 64.0

@onready var origin : Vector2 = position
var mouse_position : Vector2 = Vector2.ZERO
var last_joy : Vector2 = Vector2.ZERO
var has_controller : bool = false

func _ready() -> void:
	if Input.get_connected_joypads().size() > 0:
		has_controller = true
	Input.joy_connection_changed.connect(
		func(device : int, connected : bool):
			has_controller = connected if device == 0 else has_controller
	)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_speed : Vector2 = event.screen_relative
		mouse_position += mouse_speed * 0.125
		mouse_position = mouse_position.limit_length(EXTENTS)
		position = origin + mouse_position

func _process(delta: float) -> void:
	if has_controller:
		var axis := Input.get_vector("weapon_left", "weapon_right", "weapon_up", "weapon_down").normalized()
		axis *= EXTENTS
		if axis.length() == EXTENTS:
			position = origin + axis 
		
