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
## Whether or not debug is pressed
var debug_pressed : bool = false

func _physics_process(_delta: float) -> void:
	# Update movement vector
	movement_vector = Input.get_vector("left", "right", "up", "down")
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		queue_action(&"jump")
	if event.is_action_pressed("swing") and !swing_pressed:
		queue_action(&"swing")
	if event.is_action_pressed("throw") and !throw_pressed:
		queue_action(&"throw")
	if event.is_action_pressed("debug") and !debug_pressed:
		queue_action(&"debug")

func queue_action(action : StringName) -> void:
	match action:
		&"jump":		jump_pressed = true
		&"swing":		swing_pressed = true
		&"throw":		throw_pressed = true
		&"debug":		debug_pressed = true
	
	var timer : Timer = create_timer(0.2 if action != &"throw" else 0.05)
	timer.start()
	timer.timeout.connect(func() -> void:
		match action:
			&"jump":		jump_pressed = false
			&"swing":		swing_pressed = false
			&"throw":		throw_pressed = false
			&"debug":		debug_pressed = false
		timer.queue_free()
	)


func create_timer(time : float = 0.2) -> Timer:
	# Create timer
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = time
	add_child(timer)
	return timer
