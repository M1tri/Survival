class_name BushData
extends InteractableData

var state : Bush.State

func _init() -> void:
	type = Interactable.InteractableType.BERRY_BUSH

func GetInstance() -> Interactable:
	var scene : PackedScene = load("res://Scenes/Interactables/Bush/bush.tscn")
	var bush : Bush = scene.instantiate() as Bush
	bush.state = state
	return bush
