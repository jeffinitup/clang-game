### map_marker.gd
class_name MapMarker extends Marker2D

func _enter_tree() -> void:
	add_to_group("map_marker")
