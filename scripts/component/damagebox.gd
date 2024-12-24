### damagebox.gd
class_name Damagebox extends Area2D

## Fired when damage is done
signal hurtbox_fired(recipient : Hitbox, damage : DamagePacket)

@export_subgroup("Attributes")
## Damage to send
@export var damage : int = 1

## Velocity (if applicable)
var velocity : Vector2
## Hitboxes to blacklist
var blacklist : Array[Hitbox]

func _ready() -> void:
	# Put on hitbox layer
	collision_layer = 1 << 1
	collision_mask = 1 << 1
	
	# Connect signals
	area_entered.connect(_hitbox_entered.bind())

func _physics_process(delta: float) -> void:
	# Get velocity if applicable
	velocity = update_velocity()

func _hitbox_entered(area : Area2D) -> void:
	# Check if hitbox is hitbox and is not blacklisted
	if area in blacklist || area is not Hitbox:
		return
	
	# Send damage packet
	var packet := DamagePacket.new(damage, velocity)
	area.hitbox_harmed.emit(packet)
	hurtbox_fired.emit(area, packet)

func update_velocity() -> Vector2:
	if owner is CharacterBody2D:
		return owner.velocity
	return Vector2.ZERO

class DamagePacket extends Resource:
	var damage : int
	var knockback : Vector2
	
	func _init(damage : int, knockback : Vector2):
		self.damage = damage
		self.knockback = knockback
