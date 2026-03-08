extends Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_in"):
		zoom = zoom - Vector2(0.1, 0.1);
	elif event.is_action_pressed(("zoom_out")):
		zoom = zoom + Vector2(0.1, 0.1);
