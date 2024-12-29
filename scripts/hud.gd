### hud.gd
class_name HUD extends CanvasLayer

### Handles heads up display rendering

const SCREEN_X = 640
const SCREEN_Y = 480

## Minimap node
@onready var minimap : Control = %minimap
## Health node
@onready var health : Control = %health
