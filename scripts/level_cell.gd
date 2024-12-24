### level_cell.gd
@tool
class_name LevelCell extends Node2D

## Size of the level cell
@export var cell_size : Vector2i = Vector2i.ONE
## Reference to this cell's data
var data : Level.CellData

var last_pos : Vector2 = global_position

func _ready() -> void:
	set_notify_transform(true)

func _draw() -> void:
	draw_rect(
		Rect2(Vector2.ZERO, Vector2(640, 480) * Vector2(cell_size)), 
		Color.CRIMSON, 
		false
	)

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_TRANSFORM_CHANGED:
			if last_pos != global_position:
				global_position = to_nearest_cell(global_position)
			last_pos = global_position

func _process(_delta: float) -> void:
	queue_redraw()

func to_nearest_cell(vec : Vector2) -> Vector2:
	var fac = position / Vector2(640, 480)
	return Vector2(roundf(fac.x) * 640, roundf(fac.y) * 480)
