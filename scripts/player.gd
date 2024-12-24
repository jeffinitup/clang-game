### player.gd
class_name Player extends Entity

### Player specific functions

## Emitted when player enters new quadrant/cell
signal entered_cell(pos : Vector2i)

const DELIMITER : float = 8.0
const SPEED_CAP : float = 300.0

@onready var controller := get_node("%controller") as Controller
@onready var player_weapon := get_node("player_weapon") as PlayerWeapon
@onready var hbox := get_node("hbox") as Hitbox

var last_cell_pos : Vector2i = Vector2i.MAX

func _ready() -> void:
	player_weapon.dbox.blacklist.append(hbox)
	call_deferred("update_cell_pos")

func _physics_process(delta: float) -> void:
	update_cell_pos()

func update_physics(delta : float) -> void:
	super.update_physics(delta)
	velocity.x = clampf(velocity.x, -SPEED_CAP, SPEED_CAP)

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
		(abs(velocity.x) <= move_speed || signf(controller.movement_vector.x) != signf(velocity.x)):
		velocity.x += accel * controller.movement_vector.x

func decel_movement(decel : float) -> void:
	if (is_zero_approx(controller.movement_vector.x) || \
		signf(controller.movement_vector.x) != signf(velocity.x) || \
		abs(velocity.x) > move_speed) &&\
		abs(velocity.x) > 0:
		velocity.x += decel * (-1 if velocity.x > 0 else 1)
		if abs(velocity.x) < DELIMITER: velocity.x = 0.0 

func update_cell_pos() -> void:
	var pos := global_position / Vector2(640, 480)
	var posi := Vector2i(floori(pos.x), floori(pos.y))
	if posi != last_cell_pos:
		entered_cell.emit(posi)
	last_cell_pos = posi
