extends Node

@onready var player = $Player
@onready var terrainTileLayer = $TerrainTileLayer
@onready var worldManager : WorldManager = $WorldManager

func _ready() -> void:
	worldManager.PrepareWorld(64)
