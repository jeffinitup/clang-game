### titlescreen.gd
extends Node

## Title node
@onready var title : Label = get_node("margin/title")
## Title effect nodes
@onready var title_effect : Array[Label] = [
	title.get_node("effect1"), title.get_node("effect2")
]

func _process(delta: float) -> void:
	var time := Time.get_ticks_usec() / 1000.0
	var pos : int = 0
	for effect in title_effect:
		effect.position.x = sin(time * delta / (8 if pos != 1 else 4)) * 10
		effect.position.y = sin(time * delta / (6 if pos != 1 else 8)) * 12
		pos += 1
