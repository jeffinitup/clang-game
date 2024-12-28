### scene.gd
class_name Scene extends Node2D

## Fired when a level change is requested
signal level_change_requested(scene : Variant, context : SceneLoader.SceneContext)
