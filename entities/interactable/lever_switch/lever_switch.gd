class_name LeverSwitch
extends StaticBody2D

@export var trigger_door: Door

var is_switched: bool = false:
	set(value):
		is_switched = value
		sprite_2d.flip_h = is_switched

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready():
	await trigger_door.ready
	is_switched = not trigger_door.is_closed

func _on_interactable_component_interacted(_character):
	is_switched = not is_switched
	trigger_door.is_closed = not is_switched
