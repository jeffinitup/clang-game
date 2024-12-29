### titlescreen.gd
extends Node

## Fired when ready to start
signal ready_to_start()

## Title node
@onready var title : Label = %title
## Title effect nodes
@onready var title_effect : Array[Label] = [
	title.get_node("effect1"), title.get_node("effect2")
]
## Menu nodes
@onready var menus : Array[Control] = [
	%menu_1, %options_menu
]

func _ready() -> void:
	%start_game.grab_focus()

func _process(_delta : float) -> void:
	var time := Time.get_ticks_usec() / 100000.0
	var pos : int = 0
	for effect in title_effect:
		effect.position.x = sin(time / (7.25 if pos != 1 else -4.5)) * 8
		effect.position.y = sin(time / (-5.5 if pos != 1 else 7.5)) * 8
		pos += 1

## Menu Layer 1
##------------------------------------------------------------------------------

func start_pressed() -> void:
	ready_to_start.emit()

func configure_pressed() -> void:
	menus[0].visible = false
	menus[1].visible = true
	menus[1].entering()

func exit_pressed() -> void:
	get_tree().root.close_requested.emit()

## Menu Layer 2 ( Config )
##------------------------------------------------------------------------------

func back_pressed() -> void:
	menus[0].visible = true
	menus[1].visible = false
	%options.grab_focus()

## Menu Misc.
##------------------------------------------------------------------------------

func on_hover(element : Control) -> void:
	element.call_deferred("grab_focus")
