### player_weapon.gd
class_name PlayerWeapon extends Node2D

## Force to knock player back with
const FORCE : float = 200.0

@onready var player := owner as Player
@onready var dbox := get_node("dbox") as Damagebox
@onready var surface := get_node("surface") as RayCast2D

func get_fling_vector() -> Vector2:
	# Get angle of weapon
	var rot := wrapf(rotation + PI, -PI, PI)
	return Vector2.RIGHT.rotated(rot) * FORCE

func update_rotation() -> void:
	var mouse_pos : Vector2i = player.get_local_mouse_position()
	rotation = atan2(mouse_pos.y, mouse_pos.x)
	scale.y = -1 if mouse_pos.x < 0 else 1

func debug_print(recipient : Hitbox, damage : Damagebox.DamagePacket) -> void:
	print(recipient.owner.name + " hit for %02d damage!" % damage.damage)
