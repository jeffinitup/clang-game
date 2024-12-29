extends VBoxContainer

## Fired when ready to exit menu
signal exit_menu()

func entering() -> void:
	%music.grab_focus()

## Signals
##------------------------------------------------------------------------------

func music_changed(value : float) -> void:
	var label := %music.get_parent().get_node("label")
	label.text = "music %03d%%" % (value * 100.0)

func sound_changed(value : float) -> void:
	var label := %sound.get_parent().get_node("label")
	label.text = "sound %03d%%" % (value * 100.0)

func back_pressed() -> void:
	exit_menu.emit()

## Misc
##------------------------------------------------------------------------------

func on_hover(element : Control) -> void:
	element.call_deferred("grab_focus")
