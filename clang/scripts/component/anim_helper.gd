### anim_helper.gd
class_name AnimHelper extends Node

@export_subgroup("Nodes")
## The animation tree node
@export var anim_tree : AnimationTree

## Transitions to a specified animation state.
func change_anim(animation : String) -> void:
	# Check if anim tree exists
	if !anim_tree:
		push_error("AnimationTree does not exist!")
		return
	
	# Get variables
	var state = anim_tree.get("parameters/playback")
	var root = anim_tree.get("tree_root")

	# Check to see if state exists
	if !root.has_node(animation):
		push_error("Animation \'" + animation + "\' could not be found.")
		return

	# Travel to animation
	state.travel(animation, false)

## Forces the AnimationTree into a specific state.
func set_anim(animation : String) -> void:
	# Check if anim tree exists
	if !anim_tree:
		push_error("AnimationTree does not exist!")
		return
	
	# Get variables
	var state = anim_tree.get("parameters/playback")
	var root = anim_tree.get("tree_root")

	# Check to see if state exists
	if !root.has_node(animation):
		push_error("Animation \'" + animation + "\' could not be found.")
		return

	# Begin animation
	state.start(animation)
