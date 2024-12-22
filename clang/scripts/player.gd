### player.gd
class_name Player extends Entity

### Player specific functions

const DELIMITER : float = 2.0
const SPEED_CAP : float = 160.0

@onready var controller := get_node("%controller") as Controller
@onready var player_weapon := get_node("player_weapon") as PlayerWeapon
@onready var hbox := get_node("hbox") as Hitbox

func _ready() -> void:
	#super._ready()
	player_weapon.dbox.blacklist.append(hbox) 

func update_physics(delta : float) -> void:
	super.update_physics(delta)
	velocity.limit_length(SPEED_CAP)

func update_movement(delta : float, drag : float = 1.0) -> void:
	var accel := acceleration * drag
	var decel := deacceleration * drag
	accel_movement(accel)
	decel_movement(decel)

func update_air_movement(delta : float, drag : float = 1.0) -> void:
	var accel := acceleration * drag
	accel_movement(accel)

func accel_movement(accel : float) -> void:
	if !is_zero_approx(controller.movement_vector.x) &&\
		(abs(velocity.x) < move_speed || sign(controller.movement_vector.x) != sign(velocity.x)):
		velocity.x += accel * controller.movement_vector.x

func decel_movement(decel : float) -> void:
	if is_zero_approx(controller.movement_vector.x) &&\
		abs(velocity.x) > 0:
		velocity.x += decel * (-1 if velocity.x > 0 else 1)
		if abs(velocity.x) < DELIMITER: velocity.x = 0.0 
