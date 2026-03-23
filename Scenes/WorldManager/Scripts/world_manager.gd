class_name WorldManager
extends Node

const RENDER_DISTANCE = 1

@export var player : CharacterBody2D
@export var terrainTilesLayer : TileMapLayer

var m_loadedChunks : Dictionary[Vector2i, Chunk]
var m_worldSize : int
var m_chunkBaseMap : Dictionary[Vector2i, Chunk.ChunkBaseType]
var m_structures : Array[Structure]

func PrepareWorld(worldSize : int):
	m_worldSize = worldSize
	var worldGenerator = WorldGenerator.new(m_worldSize)
	worldGenerator.GenerateChunkBaseTypes()
	m_chunkBaseMap = worldGenerator.GetChunkBaseMap()
	m_structures = worldGenerator.GetStructures()
	
	m_loadedChunks = {}

func _process(_delta: float) -> void:
	var playerChunkPos = floor(player.global_position / 1024)
	
	for i in range(-RENDER_DISTANCE, RENDER_DISTANCE+1):
		for j in range(-RENDER_DISTANCE, RENDER_DISTANCE+1):
			var chunk_pos = Vector2i(playerChunkPos.x+i, playerChunkPos.y+j)
			if (chunk_pos not in m_loadedChunks and chunk_pos in m_chunkBaseMap):
				var chunk : Chunk = GenerateChunk(chunk_pos)
				m_loadedChunks[chunk_pos] = chunk
				PlaceChunkAt(chunk_pos, chunk)

func GenerateChunk(chunkPos : Vector2i) -> Chunk:
	var chunkBaseType : Chunk.ChunkBaseType = m_chunkBaseMap[chunkPos]
	
	var m_terrainTiles : Dictionary[Vector2i, Chunk.TerrainTileData]
	
	if (chunkBaseType in [Chunk.ChunkBaseType.GRASS, Chunk.ChunkBaseType.SNOW]):
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
	
	for structure in m_structures:
		if structure.IsInChunk(chunkPos):
			structure.PlaceInChunk(chunkPos, m_terrainTiles)
	
	var chunk = Chunk.new(chunkBaseType, m_terrainTiles, null, null)
	
	var fileName : String = str(chunkPos)
	chunk.SaveToFile("res://" + fileName + ".tres")
	
	return chunk

func PlaceChunkAt(chunkPos : Vector2i, chunkData : Chunk):
	var globalTileXPos = chunkPos.x * 32
	var globlTileYPos = chunkPos.y * 32
	for cell in chunkData.m_terrainTiles:
		var data : Chunk.TerrainTileData = chunkData.m_terrainTiles[cell]
		terrainTilesLayer.set_cell(Vector2i(cell.x + globalTileXPos, cell.y + globlTileYPos), data.m_srcId, data.m_attlassCoords)

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
