# bobble_sprite.gd
extends ColorRect

## Spring dampening
@export var dampening : float = 0.15
## Spring tension
@export var tension : float = 0.2
## Maximum distance the sprite can go from origin
@export var max_distance : Vector2 = Vector2(8.0, -8.0)

@export var physics_factor : float = 2.0
@export var physics_extents : Vector2 = Vector2(8.0, 8.0)

## Starting position
@onready var start_pos : Vector2 = position

var target_pos : Vector2 = Vector2.ZERO
var int_velocity : Vector2 = Vector2.ZERO
var strength : Vector2 = Vector2.ZERO
var speed : Vector2 = Vector2.ZERO

func _physics_process(delta) -> void:
	strength = owner.controller.movement_vector
	
	# Calculate current input strength
	# and consequential displacement
	int_velocity     = lerp(int_velocity, interpret_velocity(delta), 0.2)
	target_pos       = (start_pos + int_velocity + (max_distance * strength))
	var displacement = (target_pos - position)
	speed += (tension * displacement) - (dampening * speed)
	
	# Apply to position if enabled
	position += speed

func interpret_velocity(delta : float) -> Vector2:
	owner = owner as Entity
	var max_spd = owner.move_speed * delta
	var current_spd = owner.velocity
	var interpret = (current_spd / max_spd) * -physics_factor
	
	return Vector2(
		clampf(interpret.x, -physics_extents.x, physics_extents.y),
		clampf(interpret.y, -physics_extents.y, physics_extents.y)
	)
