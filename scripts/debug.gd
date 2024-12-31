### debug.gd
extends Node

func _enter_tree() -> void:
	# Fix "Test Current Scene"
	await get_tree().current_scene.ready
	if get_tree().current_scene.name != "main":
		var path := get_tree().current_scene.scene_file_path
		get_tree().call_deferred("change_scene_to_file", "res://scene/main.tscn")
		await get_tree().node_added
		var sl := get_tree().current_scene.get_node("scene_loader") as SceneLoader
		await sl.ready
		sl.load_scene(path)
