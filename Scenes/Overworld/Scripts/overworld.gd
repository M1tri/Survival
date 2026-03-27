extends Node

@onready var player = $Player
@onready var terrainTileLayer = $TerrainTileLayer
@onready var decorationTileLayer = $DecorationTileLayer

const RENDER_DISTANCE : int = 3

var chunkGenerator : ChunkGenerator

const save : bool = false

var playerChunkPos : Vector2i = Vector2i(-1, -1)

const fileName : String = "warudo"
const worldSize : int = 64

var m_loadedChunk : Dictionary[Vector2i, Chunk] = {}

func _ready() -> void:
	if not FileAccess.file_exists("res://" + fileName + ".tres"):
		GenerateWorld(worldSize)
	
	chunkGenerator = preload("res://Scenes/Chunk/ChunkGenerator/ChunkGenerator.tscn").instantiate()
	chunkGenerator.worldName = fileName
	chunkGenerator.ChunkGenerated.connect(ChunkGeneratedHandler)
	add_child(chunkGenerator)

func GenerateWorld(worldSize : int):
	var worldGenerator = WorldGenerator.new(worldSize)
	worldGenerator.GenerateChunkBaseTypes()
	
	var worldData : WorldData = WorldData.new()
	worldData.worldName = fileName
	worldData.worldSize = worldSize
	worldData.chunkTypeMap = worldGenerator.GetChunkBaseMap()
	worldData.structures = worldGenerator.GetStructures()
	
	ResourceSaver.save(worldData, "res://" + fileName + ".tres")

func ChunkGeneratedHandler(chunkPos : Vector2i, chunk : Chunk):
	PlaceChunk(chunkPos, chunk)
	m_loadedChunk[chunkPos] = chunk

func _process(_delta: float) -> void:
	var newPlayerChunkPos = Vector2i(player.global_position.x / 32, player.global_position.y / 32)
	newPlayerChunkPos = Vector2i(newPlayerChunkPos.x / 32, newPlayerChunkPos.y/32)
	
	if (newPlayerChunkPos != playerChunkPos):
		playerChunkPos = newPlayerChunkPos
		print(playerChunkPos)
		UpdateLoadedChunks()
	
func UpdateLoadedChunks():
	
	var chunksToKeepOrLoad : Array[Vector2i] = []
	
	for i in range(-RENDER_DISTANCE, RENDER_DISTANCE+1):
		for j in range(-RENDER_DISTANCE, RENDER_DISTANCE+1):
			var chunk_pos = Vector2i(playerChunkPos.x+i, playerChunkPos.y+j)
			@warning_ignore("integer_division")
			if chunk_pos.x < -worldSize/2 or chunk_pos.x >= worldSize/2:
				continue
			@warning_ignore("integer_division")
			if chunk_pos.y < -worldSize/2 or chunk_pos.y >= worldSize/2:
				continue
			
			chunksToKeepOrLoad.append(chunk_pos)
	
	var chunksToUnload : Array[Vector2i] = []
	var chunksToload : Array[Vector2i] = chunksToKeepOrLoad.duplicate(true)
	
	for chunkPos in m_loadedChunk:
		if not (chunkPos in chunksToKeepOrLoad):
			chunksToUnload.append(chunkPos)
		else:
			chunksToload.erase(chunkPos)
	
	for chunkPos in chunksToUnload:
		UnloadChunk(chunkPos)
		m_loadedChunk.erase(chunkPos)
	
	chunkGenerator.GenerateChunks(chunksToload)

func PlaceChunk(chunkPos : Vector2i, chunk : Chunk):
	var globalTileXPos = chunkPos.x * 32
	var globlTileYPos = chunkPos.y * 32
	for cell in chunk.m_terrainTiles:
		var data : Chunk.TerrainTileData = chunk.m_terrainTiles[cell]
		terrainTileLayer.set_cell(Vector2i(cell.x + globalTileXPos, cell.y + globlTileYPos), data.m_srcId, data.m_attlassCoords)
		
	for cell in chunk.m_decorationTiles:
		var data : Chunk.DecorationTileData = chunk.m_decorationTiles[cell]
		decorationTileLayer.set_cell(Vector2i(cell.x + globalTileXPos, cell.y + globlTileYPos), data.m_srcId, data.m_attlassCoords)


func UnloadChunk(chunkPos : Vector2i):
	var globalTileXPos = chunkPos.x * 32
	var globalTileYPos = chunkPos.y * 32
	for i in range(32):
		for j in range(32):
			var tilePos : Vector2i = Vector2i(globalTileXPos + i, globalTileYPos + j)
			terrainTileLayer.erase_cell(tilePos)
			decorationTileLayer.erase_cell(tilePos)
