class_name WorldGenerator
extends RefCounted

var generatedBaseTypes : bool
var m_worldSize : int
var m_chunkBaseMap : Dictionary[Vector2i, Chunk.ChunkBaseType]

func _init(worldSize : int) -> void:
	m_worldSize = worldSize
	m_chunkBaseMap = {}

func GenerateChunkBaseTypes():
	@warning_ignore("integer_division")
	for i in range(-m_worldSize/2, m_worldSize/2):
		@warning_ignore("integer_division")
		for j in range(-m_worldSize/2, m_worldSize/2):
			m_chunkBaseMap[Vector2i(i, j)] = Chunk.ChunkBaseType.GRASS
	GenerateRivers()

func GenerateRivers():
	@warning_ignore("integer_division")
	var x = m_worldSize/2 - 1
	var y = 0
	
	var placedConnector : bool = false
	var connectorPos : Vector2i
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	@warning_ignore("integer_division")
	while (x >= -m_worldSize/2):
		
		if (rng.randi() % 5 == 0):
			if (randi() % 2 == 0):
				m_chunkBaseMap[Vector2i(int(x), int(y))] = Chunk.ChunkBaseType.RIVER_H_DOWN1
				y += 1
				m_chunkBaseMap[Vector2i(int(x), int(y))] = Chunk.ChunkBaseType.RIVER_H_DOWN2
			else:
				m_chunkBaseMap[Vector2i(int(x), int(y))] = Chunk.ChunkBaseType.RIVER_H_UP1
				y -= 1
				m_chunkBaseMap[Vector2i(int(x), int(y))] = Chunk.ChunkBaseType.RIVER_H_UP2
			x -= 1
			continue
		
		var chunkType = Chunk.ChunkBaseType.RIVER_H1
		if (int(abs(x)) % 2 == 0):
			chunkType = Chunk.ChunkBaseType.RIVER_H2
			
		if (not placedConnector and chunkType == Chunk.ChunkBaseType.RIVER_H2):
			if (x < 0 or randi() % 10 == 0):
				chunkType = Chunk.ChunkBaseType.RIVER_CONNECTOR
				placedConnector = true
				connectorPos = Vector2i(int(x), int(y))
		m_chunkBaseMap[Vector2i(int(x), int(y))] = chunkType
		x -= 1
		
	GenerateVerticalRiver((connectorPos))

func GenerateVerticalRiver(connectorPos : Vector2i):
	var yPos = connectorPos.y-1
	
	@warning_ignore("integer_division")
	while (yPos >= -m_worldSize/2):
		m_chunkBaseMap[Vector2i(connectorPos.x, int(yPos))] = Chunk.ChunkBaseType.RIVER_V1
		yPos -= 1

func GetChunkBaseMap() -> Dictionary[Vector2i, Chunk.ChunkBaseType]:
	return m_chunkBaseMap
