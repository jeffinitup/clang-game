### pause_screen_borders.gd
class_name PauseScreenBorders extends Control

var is_paused := false

func set_paused(mode : bool): is_paused = mode

func _draw() -> void:
	if !is_paused:
		return
	
	# Draw black borders
	var SCREEN := get_tree().root.content_scale_size
	var TRANSPARENT := Color(Color.BLACK, 0.5)
	draw_rect(Rect2i(Vector2i.ZERO, SCREEN), TRANSPARENT)
	draw_rect(Rect2i(Vector2i.ZERO, Vector2i(SCREEN.x, 48)), Color.BLACK)
	draw_rect(Rect2i(Vector2i(0, SCREEN.y - 48), Vector2i(SCREEN.x, 48)), Color.BLACK)
