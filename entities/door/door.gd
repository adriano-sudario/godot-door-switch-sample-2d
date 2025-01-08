class_name Door
extends StaticBody2D

@export var is_closed_on_ready := true

var is_closed := true:
	set(value):
		if is_closed != value:
			if value:
				animated_sprite_2d.play_backwards("open_close")
			else:
				animated_sprite_2d.play("open_close")
		
		is_closed = value
		
		set_collision_layer_value(1, is_closed)
		set_collision_mask_value(1, is_closed)

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	is_closed = is_closed_on_ready
	
	if is_closed:
		animated_sprite_2d.frame = 0
	else:
		animated_sprite_2d.frame = animated_sprite_2d.sprite_frames.get_frame_count("open_close") - 1
