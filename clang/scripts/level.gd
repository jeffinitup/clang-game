### level.gd
class_name Level extends Node2D

## Fired when reload is requested
signal reload_requested()
## Fired when cells are populated
signal cells_populated(cells : Array[CellData])
## Fired when player enters new cell
signal player_in_new_cell(cell : CellData)

## List of cells
var cells : Array[CellData]
## Cell player is currently in
var player_cell : CellData :
	set(value) : 
		player_cell = value
		player_in_new_cell.emit(player_cell)
	get : return player_cell
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_R && event.pressed:
			reload_requested.emit()

## Iterates through children and creates a set of cell data
func populate_cells() -> void:
	var markers := get_tree().get_nodes_in_group("map_marker")
	
	for child in get_children():
		if child is not LevelCell:
			continue
		
		var my_markers : Array[MapMarker] = []
		for marker in markers:
			if child.is_ancestor_of(marker):
				my_markers.append(marker)
		
		cells.append(
			CellData.new(
				Vector2i(child.position / Vector2(640,480)), 
				child.cell_size,
				false,
				my_markers
			)
		)
		
	cells_populated.emit(cells)

## Called when player enters new cell
func player_entered_cell(pos : Vector2i) -> void:
	print("Player in cell %d x %d y" % [pos.x, pos.y])
	set_deferred("player_cell", get_cell_at(pos))

## Finds cell that occupies provided space
func get_cell_at(pos : Vector2i) -> CellData:
	for cell in cells:
		var cell_pos := cell.pos
		var cell_size := cell.size
		if pos.x >= cell_pos.x && pos.x <= cell_pos.x + cell_size.x - 1 &&\
		pos.y >= cell_pos.y && pos.y <= cell_pos.y + cell_size.y - 1:
			print("Cell found at %d x %d y" % [pos.x, pos.y])
			return cell
	return null

class CellData extends Resource:
	var pos : Vector2i
	var size : Vector2i
	var explored : bool
	var markers : Array[MapMarker]
	
	func _init(
		cdpos : Vector2i, 
		cdsize : Vector2i, 
		cdexplored : bool = false,
		cdmarkers : Array[MapMarker] = []):
		self.pos = cdpos
		self.size = cdsize
		self.explored = cdexplored
		self.markers = cdmarkers
