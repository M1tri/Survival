class_name ChunkGenerator
extends Node

signal ChunkGenerated(chunkPos : Vector2i, chunk : Chunk)

@onready var worldName : String

var m_worldData : WorldData = null
func _ready() -> void:
	m_worldData = load("res://" + worldName + ".tres") as WorldData
	assert(m_worldData != null)

# TODO this will be async multithreaded someday (soon i hope lol)
func GenerateChunks(positions : Array[Vector2i]):
	for pos in positions:
		var chunk : Chunk = GenerateChunk(pos)
		ChunkGenerated.emit(pos, chunk)

func GenerateChunk(chunkPos : Vector2i) -> Chunk:
	var chunkBaseType : Chunk.ChunkBaseType = m_worldData.chunkTypeMap[chunkPos]
	
	var m_terrainTiles : Dictionary[Vector2i, Chunk.TerrainTileData]
	var decorationTiles : Dictionary[Vector2i, Chunk.DecorationTileData]
	
	if (chunkBaseType in [Chunk.ChunkBaseType.GRASS, Chunk.ChunkBaseType.SNOW, Chunk.ChunkBaseType.STONY]):
		for i in range(Chunk.CHUNK_SIZE):
			for j in range(Chunk.CHUNK_SIZE):
				var grass : Chunk.TerrainTileData = Chunk.TerrainTileData.new()
				grass.m_srcId = 3
				if (chunkBaseType == Chunk.ChunkBaseType.GRASS):
					grass.m_attlassCoords = Vector2i(0, 0)
				elif (chunkBaseType == Chunk.ChunkBaseType.SNOW):
					grass.m_attlassCoords = Vector2i(9, 0)
				m_terrainTiles[Vector2i(i, j)] = grass
	else:
		m_terrainTiles = LoadBaseChunkTypeTerrain(chunkBaseType)
	
	for structure in m_worldData.structures:
		if structure.IsInChunk(chunkPos):
			structure.PlaceInChunk(chunkPos, m_terrainTiles)
	
	if chunkBaseType == Chunk.ChunkBaseType.STONY: 
		PlaceRocks(m_terrainTiles)
	
	PopulateChunkData(m_terrainTiles, decorationTiles)
	
	var chunk = Chunk.new(chunkBaseType, m_terrainTiles, decorationTiles, null)
	
	return chunk

func PlaceRocks(tileData : Dictionary[Vector2i, Chunk.TerrainTileData]):
	var rockFill = func(pos : Vector2i):
		var stack : Array = []
		var visited : Array = []
		
		var initLifeTime : int = randi_range(5, 10)
		stack.append([pos, initLifeTime])
		
		while not stack.is_empty():
			var value : Array = stack.pop_back()
			var position : Vector2i = value[0]
			var currLifeTime : int = value[1]
			
			if currLifeTime <= 0:
				continue
			
			tileData[position] = Chunk.TerrainTileData.MakeNew(Global.TileType.STONE)
			
			for i in [-1, 0, 1]:
				for j in [-1, 0, 1]:
					var neighbour : Vector2i = Vector2i(position.x + i, position.y + j)
					if (neighbour in tileData) and (not neighbour in visited):
						stack.append([neighbour, currLifeTime - randi_range(1, 2)])
			
			visited.append(position)
	
	for i in range(randi_range(3, 8)):
		var randPos : Vector2i = Vector2i(randi_range(0, 31), randi_range(0, 31))
		
		if tileData[randPos].m_type == Global.TileType.GRASS:
			rockFill.call(randPos)

func PopulateChunkData(terrainTileData : Dictionary[Vector2i, Chunk.TerrainTileData], decorationTiles : Dictionary[Vector2i, Chunk.DecorationTileData]):
	for pos in terrainTileData:
		if terrainTileData[pos].m_type == Global.TileType.GRASS:
			var decision : int = randi_range(0, 100)
			
			if decision < 80:
				continue
			
			if decision < 90:
				decorationTiles[pos] = Chunk.DecorationTileData.MakeNew(Global.DecorationTileTypes.SNOWY_TALL_GRASS)
				continue
			
			var petals : Array[Global.DecorationTileTypes] = [Global.DecorationTileTypes.PETALS_1, Global.DecorationTileTypes.PETALS_2, Global.DecorationTileTypes.PETALS_3, Global.DecorationTileTypes.PETALS_4]
			decorationTiles[pos] = Chunk.DecorationTileData.MakeNew(petals.pick_random())
			
		elif terrainTileData[pos].m_type == Global.TileType.STONE:
			var stones : Array[Global.DecorationTileTypes] = [Global.DecorationTileTypes.ROCK_1, Global.DecorationTileTypes.ROCK_2, Global.DecorationTileTypes.ROCK_3, Global.DecorationTileTypes.ROCK_4]
			
			var decision : int = randi_range(0, 100)
			if decision < 80:
				continue
				
			decorationTiles[pos] = Chunk.DecorationTileData.MakeNew(stones.pick_random())

const ChunkBaseTypeFileNames : Dictionary[Chunk.ChunkBaseType, String] = {
	Chunk.ChunkBaseType.RIVER_H1 : "riverH1",
	Chunk.ChunkBaseType.RIVER_H2 : "riverH2",
	Chunk.ChunkBaseType.RIVER_H_UP1 : "riverH_up1",
	Chunk.ChunkBaseType.RIVER_H_UP2 : "riverH_up2",
	Chunk.ChunkBaseType.RIVER_H_DOWN1 : "riverH_down1",
	Chunk.ChunkBaseType.RIVER_H_DOWN2 : "riverH_down2",
	Chunk.ChunkBaseType.RIVER_V1 : "riverV1",
	Chunk.ChunkBaseType.RIVER_CONNECTOR : "riverConnector",
} 

func LoadBaseChunkTypeTerrain(baseType : Chunk.ChunkBaseType) -> Dictionary[Vector2i, Chunk.TerrainTileData]:
	var path : String = "res://Data/Chunks/BaseTypeTerrainTiles/"
	var filePath = path + ChunkBaseTypeFileNames[baseType] + ".dat"
	var file = FileAccess.open(filePath, FileAccess.READ)
	
	var text = file.get_as_text()
	var json = JSON.parse_string(text)
	
	var terrain : Dictionary[Vector2i, Chunk.TerrainTileData] = {}
	for pos in json:
		var value = JSON.parse_string(pos)
		var tilePos : Vector2i = Vector2i(int(value[0]), int(value[1]))
		var tile : Global.TileType = int(json[pos]) as Global.TileType
		
		terrain[tilePos] = Chunk.TerrainTileData.MakeNew(tile)
	
	return terrain
