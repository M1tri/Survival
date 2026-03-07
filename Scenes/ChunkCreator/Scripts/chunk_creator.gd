extends Node

@export var fileName : String
@export var posX : int
@export var posY : int

@onready var terrainTileLayer = $TerrainTiles

func _on_button_pressed() -> void:
	var tilemap_data = {}
	
	for i in range(32):
		for j in range(32):
			var cell = Vector2i(posX+i, posY+j)
			var srcId = terrainTileLayer.get_cell_source_id(cell)
			var attlas_coords = terrainTileLayer.get_cell_atlas_coords(cell)
			tilemap_data[Vector2i(i, j)] = [srcId, attlas_coords]
	
	var chunkData = ChunkData.new(ChunkData.ChunkType.River, tilemap_data)
	var filePath = "res://" + fileName + ".dat"
	if (chunkData.ToFile(filePath)):
		print("Napisano na " + filePath)
