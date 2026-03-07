extends Node

const RENDER_DISTANCE = 1.0
const WORLD_SIZE = 64.0

const riverPath = "res://Data/Chunks/River/"

var chunks : Dictionary = {}
var loaded_chunks = []

@onready var player = $Player
@onready var terrainTileLayer = $TerrainTileLayer

func _ready() -> void:
	for i in range(-WORLD_SIZE/2, WORLD_SIZE/2):
		for j in range(-WORLD_SIZE/2, WORLD_SIZE/2):
			chunks[Vector2i(i, j)] = ChunkData.ChunkType.Grass
	GenerateRivers()

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
	else:
		var file = ChunkData.ChunkTypeToData[chunkBaseType]
		var filePath = riverPath + file + ".dat"
		chunkData = ChunkData.FromFile(filePath)
		
	PlaceChunkAt(chunkPos, chunkData)

func PlaceChunkAt(chunkPos : Vector2i, chunkData : ChunkData):
	var globalTileXPos = chunkPos.x * 32
	var globlTileYPos = chunkPos.y * 32
	for cell in chunkData.m_tiles:
		var data = chunkData.m_tiles[cell]
		terrainTileLayer.set_cell(Vector2i(cell.x + globalTileXPos, cell.y + globlTileYPos), data[0], data[1])

func GenerateRivers():
	
	var x = WORLD_SIZE/2 - 1
	var y = 0
	
	var placedConnector : bool = false
	var connectorPos : Vector2i
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	while (x >= -WORLD_SIZE/2):
		
		if (rng.randi() % 5 == 0):
			if (randi() % 2 == 0):
				chunks[Vector2i(int(x), int(y))] = ChunkData.ChunkType.RiverVerticalDown1
				y += 1
				chunks[Vector2i(int(x), int(y))] = ChunkData.ChunkType.RiverVerticalDown2
			else:
				chunks[Vector2i(int(x), int(y))] = ChunkData.ChunkType.RiverVerticalUp1
				y -= 1
				chunks[Vector2i(int(x), int(y))] = ChunkData.ChunkType.RiverVerticalUp2
			x -= 1
			continue
		
		var chunkType = ChunkData.ChunkType.RiverHorizontalUp
		if (int(abs(x)) % 2 == 0):
			chunkType = ChunkData.ChunkType.RiverHorizontalDown
			
		if (not placedConnector and chunkType == ChunkData.ChunkType.RiverHorizontalDown):
			if (x < 0 or randi() % 10 == 0):
				chunkType = ChunkData.ChunkType.RiverConnector
				placedConnector = true
				connectorPos = Vector2i(int(x), int(y))
		chunks[Vector2i(int(x), int(y))] = chunkType
		x -= 1
	GenerateVerticalRiver((connectorPos))

func GenerateVerticalRiver(connectorPos : Vector2i):
	var yPos = connectorPos.y-1
	while (yPos > -WORLD_SIZE/2):
		chunks[Vector2i(connectorPos.x, int(yPos))] = ChunkData.ChunkType.RiverVertical
		yPos -= 1
