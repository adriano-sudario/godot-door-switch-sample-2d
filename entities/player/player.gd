class_name Character
extends CharacterBody2D

var is_flipped: bool = false:
	set(value):
		if is_flipped != value:
			scale.x *= -1
		
		is_flipped = value

const SPEED = 300.0

@onready var animated_sprite_2d = $AnimatedSprite2D

func _process(_delta):
	var direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	
	if direction.x != 0:
		velocity.x = direction.x * SPEED
		is_flipped = velocity.x < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if direction.y != 0:
		velocity.y = direction.y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	if direction != Vector2.ZERO:
		animated_sprite_2d.play("move")
	else:
		animated_sprite_2d.play("idle")

	move_and_slide()
