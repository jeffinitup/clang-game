### player_grapple.gd
class_name PlayerGrapple extends Node2D

## Fired when hook state is updated
signal hook_update(hooked : bool)

## Speed of the grappling hook
@export var hook_speed := 1000.0
## Length of the grapple hook
@export var hook_length := 300.0
## Stiffness of the grapple
@export var stiffness := 9.0
## Damping of the grapple
@export var damping := 0.1

## Reference to player
@onready var player := owner as Player
## Reference to rope node
@onready var rope : Rope2D = $rope
## Reference to grapple hook
@onready var hook : CharacterBody2D = $hook

func _ready() -> void:
	await rope.ready
	rope.start = owner
	rope.end = hook

func _process(_delta : float) -> void:
	rope.set_start(global_position)
	rope.set_last(hook.global_position)
