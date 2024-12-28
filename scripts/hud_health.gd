### hud_health.gd
class_name Health extends Control

const LIGHT := Color.WHITE
const DARK := Color.BLACK

## Copy of player's health
var health := 3
## Copy of player's max health
var max_health := 5

func _draw() -> void:
	# Draw battery shape
	draw_rect(Rect2i(Vector2i(2,2), Vector2i(20 * max_health, 30)), DARK, true)
	draw_rect(Rect2i(Vector2i(2,2), Vector2i(20 * max_health, 30)), LIGHT, false, 2.0)
	draw_rect(Rect2i(Vector2i(20 * max_health + 2, 8), Vector2i(6, 16)), LIGHT, true)
	
	# Draw battery notches
	for i in range(health):
		draw_rect(Rect2i(Vector2i(6 + (18 * i), 6), Vector2i(16, 22)), LIGHT)

func health_update(hp : int, max_hp : int) -> void:
	health = hp
	max_health = max_hp
	queue_redraw()
