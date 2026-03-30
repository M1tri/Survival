class_name Bush
extends Interactable

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

enum State {
	EMPTY,
	GROWN
}

var state : State

func _ready() -> void:
	if state == State.EMPTY:
		sprite.play("empty")
	else:
		sprite.play("grown")
