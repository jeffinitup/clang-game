### controller.gd

### Delegates player control

extends Node

## The vector of movement
var movement_vector : Vector2 = Vector2.ZERO
## Whether or not jump is pressed
var jump_pressed : bool = false
## Whether or not swing is pressed
var swing_pressed : bool = false
## Whether or not throw is pressed
var throw_pressed : bool = false

func _process(_delta: float) -> void:
	# Update movement vector
	movement_vector = Input.get_vector("left", "right", "down", "up")

func _unhandled_input(event: InputEvent) -> void:
	# Update booleans
	jump_pressed = true if event.is_action_pressed("jump") else false
	swing_pressed = true if event.is_action_pressed("swing") else false
	throw_pressed = true if event.is_action_pressed("throw") else false
