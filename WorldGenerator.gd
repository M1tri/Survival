class_name WorldGenerator
extends RefCounted

var generatedBaseTypes : bool
var m_worldSize : int
var m_chunkBaseMap : Dictionary[Vector2i, Chunk.ChunkBaseType]

var m_snowStartY : int

var m_cliff1Height : int

var m_structures : Array[Structure]

func _init(worldSize : int) -> void:
	m_worldSize = worldSize
	m_chunkBaseMap = {}

func GenerateChunkBaseTypes():
	@warning_ignore("integer_division")
	for i in range(-m_worldSize/2, m_worldSize/2):
		@warning_ignore("integer_division")
		for j in range(-m_worldSize/2, m_worldSize/2):
			m_chunkBaseMap[Vector2i(i, j)] = Chunk.ChunkBaseType.GRASS

	@warning_ignore("integer_division")
	m_snowStartY = -m_worldSize/4 - randi_range(1, 5)
	print("Snow at: ", m_snowStartY)
	@warning_ignore("integer_division")
	for j in range(-m_worldSize/2, m_snowStartY+1):
		@warning_ignore("integer_division")
		for i in range(-m_worldSize/2, m_worldSize/2):
			m_chunkBaseMap.set(Vector2i(i, j), Chunk.ChunkBaseType.SNOW)
	
	GenerateRivers()
	GenerateSnowPath()
	
	@warning_ignore("integer_division")
	m_cliff1Height = m_snowStartY/2
	GenerateCliff()

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
		
	#GenerateVerticalRiver((connectorPos))

func GenerateVerticalRiver(connectorPos : Vector2i):
	var yPos = connectorPos.y-1
	
	@warning_ignore("integer_division")
	while (yPos >= -m_worldSize/2):
		m_chunkBaseMap[Vector2i(connectorPos.x, int(yPos))] = Chunk.ChunkBaseType.RIVER_V1
		yPos -= 1

func GenerateSnowPath():
	var snowH : Chunk.TerrainTileData = Chunk.TerrainTileData.new()
	snowH.m_srcId = 3
	snowH.m_attlassCoords = Vector2i(14, 0)
	
	var snowDown1 : Chunk.TerrainTileData = Chunk.TerrainTileData.new()
	snowDown1.m_srcId = 3
	snowDown1.m_attlassCoords = Vector2i(13, 0)
	
	var snowDown2 : Chunk.TerrainTileData = Chunk.TerrainTileData.new()
	snowDown2.m_srcId = 3
	snowDown2.m_attlassCoords = Vector2i(13, 1)
	
	var snowUp1 : Chunk.TerrainTileData = Chunk.TerrainTileData.new()
	snowUp1.m_srcId = 3
	snowUp1.m_attlassCoords = Vector2i(15, 1)
	
	var snowUp2 : Chunk.TerrainTileData = Chunk.TerrainTileData.new()
	snowUp2.m_srcId = 3
	snowUp2.m_attlassCoords = Vector2i(15, 0)
	
	var chunksPathIsIn : Array[Vector2i] = []
	@warning_ignore("integer_division")
	for i in range(-m_worldSize/2, m_worldSize/2):
		chunksPathIsIn.append(Vector2i(i, m_snowStartY+1))
	
	var pathData : Dictionary[Vector2i, Chunk.TerrainTileData] = {}
	
	@warning_ignore("integer_division")
	var tileYPos = (m_snowStartY + 1) * 32 - 32/2
	
	const UP : int = -1
	const DOWN : int = 1
	
	var heightDirection : int = UP
	var distanceFromCenter : int = 0
	@warning_ignore("integer_division")
	for tileXPos in range(-m_worldSize/2 * 32, m_worldSize/2 * 32):
		var changeHeight : bool = false
		
		if randi_range(1, 10) == 5:
			changeHeight = true
		
		if changeHeight:
			if randi_range(1, 10) == 5 or abs(distanceFromCenter) > 10:
				heightDirection *= -1
			distanceFromCenter += heightDirection
			
			if heightDirection == UP:
				pathData[Vector2i(tileXPos, tileYPos)] = snowUp2
				tileYPos += UP 
				pathData[Vector2i(tileXPos, tileYPos)] = snowUp1
			elif heightDirection == DOWN:
				pathData[Vector2i(tileXPos, tileYPos)] = snowDown2
				tileYPos += DOWN
				pathData[Vector2i(tileXPos, tileYPos)] = snowDown1
		else:
			pathData[Vector2i(tileXPos, tileYPos)] = snowH
	
	m_structures.append(SnowLine.new(pathData, chunksPathIsIn))

func GenerateCliff():
	var cliffHstart : Chunk.TerrainTileData = Chunk.TerrainTileData.new()
	cliffHstart.m_srcId = 3
	cliffHstart.m_attlassCoords = Vector2i(1, 0)

	var cliffHstartDown : Chunk.TerrainTileData = Chunk.TerrainTileData.new()
	cliffHstartDown.m_srcId = 3
	cliffHstartDown.m_attlassCoords = Vector2i(1, 1)
	
	var cliffHend : Chunk.TerrainTileData = Chunk.TerrainTileData.new()
	cliffHend.m_srcId = 3
	cliffHend.m_attlassCoords = Vector2i(3, 0)

	var cliffHendDown : Chunk.TerrainTileData = Chunk.TerrainTileData.new()
	cliffHendDown.m_srcId = 3
	cliffHendDown.m_attlassCoords = Vector2i(3, 1)
	
	var cliffHmiddle : Chunk.TerrainTileData = Chunk.TerrainTileData.new()
	cliffHmiddle.m_srcId = 3
	cliffHmiddle.m_attlassCoords = Vector2i(2, 0)

	var cliffHmiddleDown : Chunk.TerrainTileData = Chunk.TerrainTileData.new()
	cliffHmiddleDown.m_srcId = 3
	cliffHmiddleDown.m_attlassCoords = Vector2i(2, 1)
	
	var cliffDown1 : Chunk.TerrainTileData = Chunk.TerrainTileData.new()
	cliffDown1.m_srcId = 3
	cliffDown1.m_attlassCoords = Vector2i(1, 2)
	
	var cliffDown2 : Chunk.TerrainTileData = Chunk.TerrainTileData.new()
	cliffDown2.m_srcId = 3
	cliffDown2.m_attlassCoords = Vector2i(1, 3)
	
	var cliffDown3 : Chunk.TerrainTileData = Chunk.TerrainTileData.new()
	cliffDown3.m_srcId = 3
	cliffDown3.m_attlassCoords = Vector2i(1, 4)
	
	var cliffUp1 : Chunk.TerrainTileData = Chunk.TerrainTileData.new()
	cliffUp1.m_srcId = 3
	cliffUp1.m_attlassCoords = Vector2i(3, 2)
	
	var cliffUp2 : Chunk.TerrainTileData = Chunk.TerrainTileData.new()
	cliffUp2.m_srcId = 3
	cliffUp2.m_attlassCoords = Vector2i(3, 3)
	
	var cliffUp3 : Chunk.TerrainTileData = Chunk.TerrainTileData.new()
	cliffUp3.m_srcId = 3
	cliffUp3.m_attlassCoords = Vector2i(3, 4)
	
	var tileData : Dictionary[Vector2i, Chunk.TerrainTileData] = {}
	@warning_ignore("integer_division")
	var tileYPos = (m_cliff1Height + 1) * 32 - 32/2
	
	var chunksPathIsIn : Array[Vector2i] = []
	@warning_ignore("integer_division")
	for i in range(-m_worldSize/2, m_worldSize/2):
		chunksPathIsIn.append(Vector2i(i, m_cliff1Height+1))
	
	var posToSkip : int = 0
	@warning_ignore("integer_division")
	for tileXPos in range(-m_worldSize/2 * 32, m_worldSize/2 * 32):
		if posToSkip > 0:
			posToSkip -= 1
			if posToSkip == 0:
				tileData[Vector2i(tileXPos, tileYPos)] = cliffHstart
				tileData[Vector2i(tileXPos, tileYPos-1)] = cliffHstartDown
			continue
		
		if randi_range(1, 20) == 5:
			tileData[Vector2i(tileXPos, tileYPos)] = cliffHend
			tileData[Vector2i(tileXPos, tileYPos-1)] = cliffHendDown
			
			posToSkip = randi_range(3, 10)
			continue
		
		if (randi_range(1, 10) == 5):
			var direction : int = [-1, 1].pick_random()
			
			if direction == 1:
				tileData[Vector2i(tileXPos, tileYPos)] = cliffUp1
				tileData[Vector2i(tileXPos, tileYPos-1)] = cliffUp2
				tileData[Vector2i(tileXPos, tileYPos-2)] = cliffUp3
				tileYPos -= 1
			else:
				tileData[Vector2i(tileXPos, tileYPos+1)] = cliffDown1
				tileData[Vector2i(tileXPos, tileYPos)] = cliffDown2
				tileData[Vector2i(tileXPos, tileYPos-1)] = cliffDown3
				tileYPos += 1
			
			continue
		
		tileData[Vector2i(tileXPos, tileYPos)] = cliffHmiddle
		tileData[Vector2i(tileXPos, tileYPos-1)] = cliffHmiddleDown
	
	m_structures.append(Cliff.new(tileData, chunksPathIsIn))

func GetChunkBaseMap() -> Dictionary[Vector2i, Chunk.ChunkBaseType]:
	return m_chunkBaseMap

func GetStructures() -> Array[Structure]:
	return m_structures
