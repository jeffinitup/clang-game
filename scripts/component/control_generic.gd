### control_generic.gd
class_name ControlGeneric extends Control

### Fired when mouse is over button
signal element_hovered(element : Control)

func _ready() -> void:
	mouse_entered.connect(on_enter.bind())

func on_enter() -> void:
	element_hovered.emit(self)
