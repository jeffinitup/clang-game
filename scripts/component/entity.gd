### entity.gd
class_name Entity extends CharacterBody2D

### Handles entity physics updates

@export_subgroup("Attributes")
## The amount of acceleration the entity has [0.0 - 1.0]
@export var acceleration : float = 0.2
## The amount of deacceleration the entity has [0.0 - 1.0]
@export var deacceleration : float = 0.1
## The movement speed of the entity
@export var move_speed : float = 50.0
## The jump height of the entity
@export var jump_height : float = 80.0
## The intended time during a jump
@export var jump_time_to_peak : float = 0.5
## The intended time after a jump
@export var jump_time_to_descent : float = 0.4

## Jump variables
@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1
@onready var jump_gravity  : float = ((-2.0 * jump_height) / (pow(jump_time_to_peak,2))) * -1
@onready var fall_gravity  : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1
## Is the entity jumping
var jumping : bool = false

func update_physics(delta: float) -> void:
	if !is_on_floor():
		velocity.y = min(velocity.y + return_gravity() * delta, 500)
	
	move_and_slide()

func return_gravity() -> float:
	return jump_gravity if velocity.y <= 0 and jumping else fall_gravity
