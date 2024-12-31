### pause_screen.gd
class_name PauseScreen extends CanvasLayer

## Fired when ready to return to menu
signal ready_for_menu()

## Fired when pause is toggled
signal pause_toggled(mode : bool)

## Menu nodes
@onready var menus : Array[Control] = [
	%menu_1, %options_menu
]
## Whether or not user has paused
var is_paused := false :
	set(value): is_paused = value; set_pause(value)
	get : return is_paused

func _ready() -> void:
	hide()

func toggle_pause() -> void:
	is_paused = !is_paused
	pause_toggled.emit(is_paused)

func set_pause(value : bool) -> void:
	# Paused
	if is_paused:
		get_tree().paused = true
		show()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Music.mute_channels([1, 3, 4, 5])
		%continue.grab_focus()
	
	# Unpaused
	else:
		get_tree().paused = false
		hide()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		Music.unmute_channels([1, 3, 4, 5])
		%continue.release_focus()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

## Menu Layer 1
##------------------------------------------------------------------------------

func continue_pressed() -> void:
	toggle_pause()

func configure_pressed() -> void:
	menus[0].visible = false
	menus[1].visible = true
	menus[1].entering()

func return_to_menu_pressed() -> void:
	ready_for_menu.emit()
	get_tree().paused = false

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
	
