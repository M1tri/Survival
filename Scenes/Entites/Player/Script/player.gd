extends CharacterBody2D

const SPEED = 1000
const JUMP_VELOCITY = -400.0

func _physics_process(_delta: float) -> void:
	var directionH := Input.get_axis("left", "right")
	if directionH:
		velocity.x = directionH * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	var directionV := Input.get_axis("up", "down")
	if directionV:
		velocity.y = directionV * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	move_and_slide()
