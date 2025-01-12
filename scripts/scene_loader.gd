### scene_loader.gd
class_name SceneLoader extends Node

enum Scenes {
	TITLE,
	TEST_LEVEL
}

## First scene to load into
@export var start : PackedScene
## Reference to player scene
@onready var player_scene := preload("res://prefab/player.tscn") as PackedScene
## Reference to hud scene
@onready var hud_scene := preload("res://prefab/hud.tscn") as PackedScene
## Reference to pause scene
@onready var pause_scene := preload("res://scene/pause_screen.tscn") as PackedScene
## Reference to player cam scene
@onready var player_cam_scene := preload("res://prefab/player_cam.tscn") as PackedScene

## Currently loaded scene
var current_scene : Node
## Player reference
var player : Player

func _ready() -> void:
	load_scene_packed(start)

func scene_change_requested(scene : Variant, context : SceneContext) -> void:
	if scene is int:
		load_scene_id(scene, context)
	if scene is String:
		load_scene(scene, context)
	if scene is PackedScene:
		load_scene_packed(scene, context)

func load_scene_packed(ps : PackedScene, sc : SceneContext = SceneContext.new()) -> Node:
	if current_scene:
		current_scene.queue_free()
	current_scene = ps.instantiate()
	
	add_child(current_scene)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if current_scene is Scene:
		current_scene.level_change_requested.connect(scene_change_requested.bind())
	
	if current_scene is Level:
		level_setup(ps, sc)
		
	return current_scene

func load_scene(path : String, sc : SceneContext = SceneContext.new()) -> Node:
	return load_scene_packed(load(path)) 

func load_scene_id(id : int, sc : SceneContext = SceneContext.new()) -> Node:
	return load_scene(id_to_path(id))

func id_to_path(id : int) -> String:
	match id:
		Scenes.TITLE:						return "uid://cddkj86qmc2fi"
		Scenes.TEST_LEVEL:					return "uid://cw0732uifkxxm"
		_:									return ""
		
func level_setup(ps : PackedScene, sc : SceneContext) -> void:
	# Get player start point
	var pos : Vector2 = Vector2.ZERO
	for spawn in get_tree().get_nodes_in_group("player_spawn"):
		if spawn is not PlayerSpawn:
			continue
		if spawn.id == sc.warp_id:
			pos = spawn.global_position
			break
	
	# Create player
	var player : Player = player_scene.instantiate()
	current_scene.add_child(player)
	player.position = pos
	
	# Create camera
	var camera : PlayerCam = player_cam_scene.instantiate()
	player.add_child(camera)
	
	# Create hud
	var hud : HUD = hud_scene.instantiate()
	current_scene.add_child(hud)
	
	# Create pause screen
	var pause : PauseScreen = pause_scene.instantiate()
	current_scene.add_child(pause)
	
	# Hook up signals
	current_scene = current_scene as Level
	hud.minimap.player = player
	
	current_scene.reload_requested.connect(load_scene_packed.bind(ps, sc))
	current_scene.cells_populated.connect(hud.minimap.cells_updated.bind())
	current_scene.player_in_new_cell.connect(hud.minimap.pcell_updated.bind())
	current_scene.player_in_new_cell.connect(camera.set_constraints.bind())
	
	player.entered_cell.connect(current_scene.player_entered_cell.bind())
	player.entered_cell.connect(hud.minimap.ppos_updated.bind())
	player.hbox.hitbox_relay.connect(hud.health.health_update.bind())
	
	pause.ready_for_menu.connect(load_scene_id.bind(0))
	
	# Run initialization
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	current_scene.populate_cells()
	hud.health.health_update(player.hbox.hp, player.hbox.max_hp)

class SceneContext extends Resource:
	var warp_id : int = 0
	
	func _init(warp_id : int = 0):
		self.warp_id = warp_id
