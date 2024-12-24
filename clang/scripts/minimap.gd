### minimap.gd
class_name Minimap extends Control

## Mirror of cell list
var cells : Array[Level.CellData]
## Mirror of current cell
var player_cell : Level.CellData
## Mirror of player's current cell position
var player_pos : Vector2i
## Player reference
@onready var player : Player = get_tree().get_first_node_in_group("player")

func _draw() -> void:
	var TRANSPARENT := Color(Color.DARK_GRAY, 0.5)
	var SOLID := Color.WHITE
	var CELL := Color.DIM_GRAY
	var MY_CELL := Color.RED
	
	var CENTER := Vector2i(size / 2)
	var MARGIN := Vector2(1, 1)
	var SIZE := Vector2i(20, 15)
	
	draw_rect(Rect2i(MARGIN, size - MARGIN), TRANSPARENT, true)
	
	for cell in cells:
		var cpos := cell.pos * SIZE + ((CENTER + -player_pos * SIZE) - SIZE / 2)
		var csize := cell.size * SIZE
		draw_rect(
			Rect2i(cpos, csize), 
			Color(CELL, 0.4) if cell != player_cell else Color(MY_CELL, 0.4), true
		)
		draw_rect(
			Rect2i(Vector2(cpos) + MARGIN, Vector2(csize) - MARGIN),
			CELL if cell != player_cell else MY_CELL, false
		)
	
	draw_rect(
		Rect2i(
			Vector2i((wrapi(player.position.x, 0, 640)), wrapi(player.position.y, 0, 480)
			) / 32 + CENTER - SIZE / 2,
			Vector2i(2,2)
		),
		SOLID, true
	)
	
	draw_rect(Rect2i(MARGIN, size - MARGIN), SOLID, false)

func _process(delta: float) -> void:
	queue_redraw()

func cells_updated(list : Array[Level.CellData]) -> void:
	cells = list

func pcell_updated(cell : Level.CellData) -> void:
	player_cell = cell

func ppos_updated(pos : Vector2i) -> void:
	player_pos = pos
