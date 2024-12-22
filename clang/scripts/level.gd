### level.gd
class_name Level extends Node2D

## Fired when reload is requested
signal reload_requested()

## List of cells
var cells : Array[CellData]
## Cell player is currently in
var player_cell : CellData

func _ready() -> void:
	populate_cells()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_R && event.pressed:
			get_tree().reload_current_scene()

## Iterates through children and creates a set of cell data
func populate_cells() -> void:
	for child in get_children():
		if child is not LevelCell:
			continue
		cells.append(
			CellData.new(
				Vector2i(child.position / Vector2(640,480)), 
				child.cell_size
			)
		)

class CellData extends Resource:
	var pos : Vector2i
	var size : Vector2i
	var explored : bool
	
	func _init(pos : Vector2i, size : Vector2i, explored : bool = false):
		self.pos = pos
		self.size = size
		self.explored = explored
