### player_weapon.gd
class_name PlayerWeapon extends Node2D

@onready var player := owner as Player
@onready var dbox := get_node("dbox") as Damagebox

func update_rotation() -> void:
	var mouse_pos : Vector2i = player.get_local_mouse_position()
	rotation = atan2(mouse_pos.y, mouse_pos.x)
	scale.y = -1 if mouse_pos.x < 0 else 1

func debug_print(recipient : Hitbox, damage : Damagebox.DamagePacket) -> void:
	print(recipient.owner.name + " hit for %02d damage!" % damage.damage)
