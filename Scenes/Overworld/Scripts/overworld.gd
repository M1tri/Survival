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
	
	var map = {
		Vector2i(0, 0) : Global.TileType.GRASS,
		Vector2i(5, 1) : Global.TileType.WATER,
		Vector2i(4, 0) : Global.TileType.WATER_GRASS_START_TOP,
		Vector2i(5, 0) : Global.TileType.WATER_GRASS_MIDDLE_TOP,
		Vector2i(6, 0) : Global.TileType.WATER_GRASS_END_TOP,
		Vector2i(4, 1): Global.TileType.WATER_GRASS_LEFT,
		Vector2i(6, 1): Global.TileType.WATER_GRASS_RIGHT ,
		Vector2i(4, 2) : Global.TileType.WATER_GRASS_START_BOTTOM,
		Vector2i(5, 2) : Global.TileType.WATER_GRASS_MIDDLE_BOTTOM ,
		Vector2i(6, 2) : Global.TileType.WATER_GRASS_END_BOTTOM,
		Vector2i(4, 3) : Global.TileType.WATER_GRASS_ISLAND_TOP_LEFT ,
		Vector2i(5, 3) : Global.TileType.WATER_GRASS_ISLAND_TOP_RIGHT ,
		Vector2i(4, 4) : Global.TileType.WATER_GRASS_ISLAND_BOTTOM_LEFT,
		Vector2i(5, 4) : Global.TileType.WATER_GRASS_ISLAND_BOTTOM_RIGHT 
	}
	
	var tiles : Dictionary[Array, Global.TileType] = {}
	for i in range(32):
		for j in range(32):
			#var srcId = terrainTileLayer.get_cell_source_id(Vector2i(startX + i, startY + j))
			var attlasCoords : Vector2i = terrainTileLayer.get_cell_atlas_coords(Vector2i(startX+i, startY+j))
			tiles[[i, j]] = map[attlasCoords]
	
	var txt = JSON.stringify(tiles, "\t")
	file.store_string(txt)
	file.close()
