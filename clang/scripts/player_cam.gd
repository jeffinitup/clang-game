### player_cam.gd
class_name PlayerCam extends Camera2D

var last_cd : Level.CellData

func set_constraints(cd : Level.CellData) -> void:
	if cd == last_cd:
		return
	
	if !cd:
		limit_left = -10000000
		limit_top = -10000000
		limit_right = 10000000
		limit_bottom = 10000000
		last_cd = null
		return
	
	var pos := cd.pos
	var size := cd.size
	limit_left = pos.x * 640
	limit_right = (pos.x + cd.size.x) * 640
	limit_top = pos.y * 480
	limit_bottom = (pos.y + cd.size.y) * 480 
	last_cd = cd
