### hitbox.gd
class_name Hitbox extends Area2D

## Fired when harmed
signal hitbox_harmed(packet : Damagebox.DamagePacket)
## Fired when health is below 0
signal hitbox_death()

@export_subgroup("Attributes")
## The maximum amount of hit points
@export var max_hp : int = 1
## Seconds of invulnerability provided
@export var invincibility_time : float = 0.5

## Current hit points
@onready var hp : int = max_hp
## Invulnerability timer
var i_timer : Timer
## Debug font
@onready var font = preload("res://asset/font/PixelOperatorMono.ttf")

func _ready() -> void:
	# Create inv timer
	i_timer = Timer.new()
	i_timer.wait_time = invincibility_time
	i_timer.one_shot = true
	add_child(i_timer)
	
	# Put on hitbox layer
	collision_layer |= 1 << 1
	collision_mask |= 1 << 1
	
	# Connect signals
	hitbox_harmed.connect(harmed.bind())
	i_timer.timeout.connect(invulnerability_done.bind())

func _draw() -> void:
	draw_string(font, get_child(0).position + Vector2.DOWN * 36, "%02d/%02d" % [hp, max_hp])
	if owner is CharacterBody2D:
		draw_string(font, get_child(0).position + Vector2.DOWN * 48, "%d" % owner.velocity.x)

func _process(_delta: float) -> void:
	queue_redraw()

func harmed(packet : Damagebox.DamagePacket) -> void:
	# Apply damage and knockback
	hp -= packet.damage
	if owner is CharacterBody2D:
		owner.velocity += packet.knockback
	
	# Die if applicable
	if hp <= 0:
		hitbox_death.emit()
	
	# Invuln
	for child in get_children():
		if child is CollisionShape2D:
			child.set_deferred("disabled", true)
	i_timer.start()

func invulnerability_done() -> void:
	# No more invulnerable
	for child in get_children():
		if child is CollisionShape2D:
			child.set_deferred("disabled", false)