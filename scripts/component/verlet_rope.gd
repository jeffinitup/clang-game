### verlet_rope.gd
class_name Rope2D extends Node2D

@export var rope_length : float = 30 :
	set(value) : rope_length = value; resize()
@export var rope_limit : float = 60
@export var constrain : float = 1 
@export var gravity : Vector2 = Vector2(0, 9.8)
@export var dampening : float = 0.9
@export var startPin : bool = true
@export var endPin : bool = true

@onready var o_pos : Vector2 = position

var start : Node2D
var end : Node2D 
var pos : PackedVector2Array
var pos_prev : PackedVector2Array
var point_count: int

func _ready()->void:
	# Create ends
	start = Marker2D.new()
	end = Marker2D.new()
	add_child(start)
	add_child(end)
	
	resize()
	init_position()

func resize() -> void:
	point_count = get_point_count(rope_length)
	resize_arrays()

func get_point_count(distance: float)->int:
	return int(ceil(distance / constrain))

func resize_arrays():
	pos.resize(point_count)
	pos_prev.resize(point_count)

func init_position()->void:
	# Set markers
	start.position = o_pos
	end.position = o_pos + Vector2(constrain * (point_count - 1), 0)
	
	for i in range(point_count):
		pos[i] = o_pos + Vector2(constrain * i, 0)
		pos_prev[i] = o_pos + Vector2(constrain * i, 0)

#func _unhandled_input(event:InputEvent)->void:
	#if event is InputEventMouseMotion:
		#if Input.is_action_pressed("swing"):	#Move start point
			#set_start(get_global_mouse_position())
		#if Input.is_action_pressed("throw"):	#Move start point
			#set_last(get_global_mouse_position())
	#elif event is InputEventMouseButton && event.is_pressed():
		#if event.button_index == 1:
			#set_start(get_global_mouse_position())
		#elif event.button_index == 2:
			#set_last(get_global_mouse_position())

func _physics_process(delta : float) -> void:
	update_points(delta)
	update_constrain()

func _process(_delta : float) -> void:
	queue_redraw()

func _draw() -> void:
	draw_polyline(pos, Color.WHITE, 1.0)
	draw_rect(Rect2i(Vector2i(start.position - Vector2.ONE * 2), Vector2i(4, 4)), Color.RED, true)
	draw_rect(Rect2i(Vector2i(end.position - Vector2.ONE * 2), Vector2i(4, 4)), Color.RED, true)


func set_start(p:Vector2)->void:
	# Localize vector
	var vec : Vector2 = end.to_local(p)
	vec = vec.limit_length(rope_limit)
	
	start.position = end.position + vec
	pos[0] = start.position
	pos_prev[0] = start.position

func set_last(p:Vector2)->void:
	# Localize vector
	var vec : Vector2 = start.to_local(p)
	vec = vec.limit_length(rope_limit)
	
	end.position = start.position + vec
	pos[point_count-1] = end.position
	pos_prev[point_count-1] = end.position

func update_points(delta)->void:
	for i in range (point_count):
		# not first and last || first if not pinned || last if not pinned
		if (i!=0 && i!=point_count-1) || (i==0 && !startPin) || (i==point_count-1 && !endPin):
			var velocity = (pos[i] -pos_prev[i]) * dampening
			pos_prev[i] = pos[i]
			pos[i] += velocity + (gravity * delta)

func update_constrain()->void:
	for i in range(point_count):
		if i == point_count-1:
			return
		var distance = pos[i].distance_to(pos[i+1])
		var difference = constrain - distance
		var percent = difference / distance
		var vec2 = pos[i+1] - pos[i]
		
		# if first point
		if i == 0:
			if startPin:
				pos[i+1] += vec2 * percent
			else:
				pos[i] -= vec2 * (percent/2)
				pos[i+1] += vec2 * (percent/2)
		# if last point, skip because no more points after it
		elif i == point_count-1:
			pass
		# all the rest
		else:
			if i+1 == point_count-1 && endPin:
				pos[i] -= vec2 * percent
			else:
				pos[i] -= vec2 * (percent/2)
				pos[i+1] += vec2 * (percent/2)
