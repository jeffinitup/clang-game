### controller.gd

### Delegates player control

class_name Controller extends Node

## The vector of movement
var movement_vector : Vector2 = Vector2.ZERO
## Whether or not jump is pressed
var jump_pressed : bool = false
## Whether or not swing is pressed
var swing_pressed : bool = false
## Whether or not throw is pressed
var throw_pressed : bool = false

## Input queueing timer
var timer : Timer

func _ready() -> void:
	# Create timer
	timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = 0.3
	add_child(timer)
	timer.timeout.connect(
		func() -> void:
			jump_pressed = false
	)

func _process(_delta: float) -> void:
	# Update movement vector
	movement_vector = Input.get_vector("left", "right", "down", "up")

func _unhandled_input(event: InputEvent) -> void:
	# Update booleans
	if event.is_action_pressed("jump"): queue_jump()
	swing_pressed = true if event.is_action_pressed("swing") else false
	throw_pressed = true if event.is_action_pressed("throw") else false

func queue_jump() -> void:
	print("queue")
	timer.start()
	jump_pressed = true
