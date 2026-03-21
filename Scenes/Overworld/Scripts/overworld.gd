extends Node

@onready var player = $Player
@onready var terrainTileLayer = $TerrainTileLayer
@onready var worldManager : WorldManager = $WorldManager

const save : bool = false

var playerChunkPos : Vector2i

func _ready() -> void:
	worldManager.PrepareWorld(64)
	if save:
		for pos in chunksToSave:
			SaveChunks(pos, chunksToSave[pos])

func _process(_delta: float) -> void:
	var newPlayerChunkPos = Vector2i(player.global_position.x / 32, player.global_position.y / 32)
	newPlayerChunkPos = Vector2i(newPlayerChunkPos.x / 32, newPlayerChunkPos.y/32)
	
	if (newPlayerChunkPos != playerChunkPos):
		playerChunkPos = newPlayerChunkPos
		print(playerChunkPos)

var chunksToSave = {
	Vector2i(0, 0) : "riverH1",
	Vector2i(1, 0) : "riverH2",
	
	Vector2i(2, 0) : "riverH_up2",
	Vector2i(2, 1) : "riverH_up1",
	
	Vector2i(-1, 0) : "riverH_down1",
	Vector2i(-1, 1) : "riverH_down2",
	
	Vector2i(-3, 1) : "riverConnector",
	
	Vector2i(-3, 0) : "riverV1",
	Vector2i(-3, -1) : "riverV2"
}

func SaveChunks(chunkPos, fileName):
	var path = "res://"
	var file = FileAccess.open(path + fileName + ".dat", FileAccess.WRITE)
	
	var startX = chunkPos.x * 32
	var startY = chunkPos.y * 32
	
	var tiles : Dictionary[Array, Array] = {}
	for i in range(32):
		for j in range(32):
			var srcId = terrainTileLayer.get_cell_source_id(Vector2i(startX + i, startY + j))
			var attlasCoords = terrainTileLayer.get_cell_atlas_coords(Vector2i(startX+i, startY+j))
			tiles[[i, j]] = [srcId, attlasCoords.x, attlasCoords.y]
	
	var txt = JSON.stringify(tiles, "\t")
	file.store_string(txt)
	file.close()
