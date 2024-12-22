### player.gd
class_name Player extends Entity

### Player specific functions

@onready var player_controller := get_node("%controller") as Controller
@onready var player_weapon := get_node("player_weapon") as PlayerWeapon
@onready var hbox := get_node("hbox") as Hitbox

func _ready() -> void:
	#super._ready()
	player_weapon.dbox.blacklist.append(hbox) 
