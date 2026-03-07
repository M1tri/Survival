extends Node

const RENDER_DISTANCE = 1

var chunks : Dictionary = {}
var loaded_chunks = []

@onready var player = $Player
@onready var terrainTileLayer = $TerrainTileLayer

func _ready() -> void:
	for i in range(-16, 16):
		for j in range(-16, 16):
			chunks[Vector2i(i, j)] = ChunkData.ChunkType.Grass

func _process(_delta : float):
	
	var playerChunkPos = floor(player.global_position / 1024)
	print("Player chunk pos:" + str(playerChunkPos))
	
	for i in range(-RENDER_DISTANCE, RENDER_DISTANCE+1):
		for j in range(-RENDER_DISTANCE, RENDER_DISTANCE+1):
			var chunk_pos = Vector2i(playerChunkPos.x+i, playerChunkPos.y+j)
			if (chunk_pos not in loaded_chunks and chunk_pos in chunks):
				LoadChunk(chunk_pos)
				loaded_chunks.append(chunk_pos)

func LoadChunk(chunkPos : Vector2i):
	var chunkBaseType = chunks[chunkPos]
	
	var chunkData : ChunkData 
	if (chunkBaseType == ChunkData.ChunkType.Grass):
		var tiles = {}
		for i in range(32):
			for j in range(32):
				tiles[Vector2i(i, j)] = [0, Vector2i(1, 0)]
		chunkData = ChunkData.new(ChunkData.ChunkType.Grass, tiles)
		
	PlaceChunkAt(chunkPos, chunkData)

func PlaceChunkAt(chunkPos : Vector2i, chunkData : ChunkData):
	var globalTileXPos = chunkPos.x * 32
	var globlTileYPos = chunkPos.y * 32
	for cell in chunkData.m_tiles:
		var data = chunkData.m_tiles[cell]
		terrainTileLayer.set_cell(Vector2i(cell.x + globalTileXPos, cell.y + globlTileYPos), data[0], data[1])
