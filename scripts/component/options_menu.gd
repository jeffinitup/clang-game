extends VBoxContainer

## Fired when ready to exit menu
signal exit_menu()

## Sound effect to play when setting sound volume
@onready var sfx := $sfx

func entering() -> void:
	%music.grab_focus()

## Signals
##------------------------------------------------------------------------------

func music_changed(value : float) -> void:
	# Set config
	Config.data.vol_music = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))
	
	# Update label
	var label := %music.get_parent().get_node("label")
	label.text = "music %03d%%" % (value * 100.0)

func sound_changed(value : float) -> void:
	# Set config
	Config.data.vol_sound = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound"), linear_to_db(value))
	sfx.play()
	
	# Update label
	var label := %sound.get_parent().get_node("label")
	label.text = "sound %03d%%" % (value * 100.0)

func back_pressed() -> void:
	Config.save_config()
	exit_menu.emit()

## Misc
##------------------------------------------------------------------------------

func on_hover(element : Control) -> void:
	element.call_deferred("grab_focus")
