extends Node

@onready var player = $Player
@onready var terrainTileLayer = $TerrainTileLayer
@onready var decorationTileLayer = $DecorationTileLayer

const RENDER_DISTANCE : int = 3

var chunkGenerator : ChunkGenerator

var playerChunkPos : Vector2i = Vector2i(-1, -1)

const fileName : String = "warudo"
const worldSize : int = 64

var m_loadedChunk : Dictionary[Vector2i, Chunk] = {}

func _ready() -> void:
	var worldSaveDirectory : String = Global.SaveDirectory + fileName
	
	if not DirAccess.dir_exists_absolute(worldSaveDirectory):
		DirAccess.make_dir_absolute(worldSaveDirectory)
		DirAccess.make_dir_absolute(worldSaveDirectory + "/Chunks")
	
	var worldData : WorldData
	if not FileAccess.file_exists(worldSaveDirectory + "/" + fileName + ".tres"):
		worldData = GenerateWorld(worldSize)
		ResourceSaver.save(worldData, worldSaveDirectory + "/" + fileName + ".tres")
	else:
		worldData = load(worldSaveDirectory + "/" + fileName + ".tres") as WorldData
	
	chunkGenerator = preload("res://Scenes/Chunk/ChunkGenerator/ChunkGenerator.tscn").instantiate()
	chunkGenerator.file = worldSaveDirectory + "/" + fileName + ".tres"
	chunkGenerator.m_worldData = worldData
	chunkGenerator.chunkFilesFolder = worldSaveDirectory + "/Chunks"
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
	
	return worldData

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
	
	"""
	var worldChunksDirectory : String = Global.SaveDirectory + fileName + "/Chunks"
	var tmp : Array = chunksToload.duplicate()
	for chunkPos in chunksToload:
		var chunkFileName : String = str(chunkPos) + ".tres"
		if FileAccess.file_exists(worldChunksDirectory + "/" + chunkFileName):
			var chunk : Chunk = Chunk.FromFile(worldChunksDirectory + "/" + chunkFileName)
			PlaceChunk(chunkPos, chunk)
			m_loadedChunk[chunkPos] = chunk
			tmp.erase(chunkPos)
	"""
	
	chunkGenerator.GenerateChunks(chunksToload)

func PlaceChunk(chunkPos : Vector2i, chunk : Chunk):
	var globalTileXPos = chunkPos.x * 32
	var globlTileYPos = chunkPos.y * 32
	for cell in chunk.m_terrainTiles:
		var data : Global.TileType = chunk.m_terrainTiles[cell]
		var srcId : int = Global.TileTypeData[data][Global.TileSrcID]
		var attlasCoords : Vector2i = Global.TileTypeData[data][Global.TileAttlassCoords]
		terrainTileLayer.set_cell(Vector2i(cell.x + globalTileXPos, cell.y + globlTileYPos), srcId, attlasCoords)
		
	for cell in chunk.m_decorationTiles:
		var data : Global.DecorationTileTypes = chunk.m_decorationTiles[cell]
		var srcId : int = Global.DecorationTileTypeData[data][Global.TileSrcID]
		var attlasCoords : Vector2i = Global.DecorationTileTypeData[data][Global.TileAttlassCoords]
		decorationTileLayer.set_cell(Vector2i(cell.x + globalTileXPos, cell.y + globlTileYPos), srcId, attlasCoords)


func UnloadChunk(chunkPos : Vector2i):
	var worldChunksDirectory : String = Global.SaveDirectory + fileName + "/Chunks"
	var chunkName : String = str(chunkPos) + ".tres"
	var chunkPath : String = worldChunksDirectory + "/" + chunkName
	
	var globalTileXPos = chunkPos.x * 32
	var globalTileYPos = chunkPos.y * 32
	for i in range(32):
		for j in range(32):
			var tilePos : Vector2i = Vector2i(globalTileXPos + i, globalTileYPos + j)
			terrainTileLayer.erase_cell(tilePos)
			decorationTileLayer.erase_cell(tilePos)
	
	m_loadedChunk[chunkPos].SaveToFile(chunkPath)
