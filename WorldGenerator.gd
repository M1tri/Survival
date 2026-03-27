class_name WorldGenerator
extends RefCounted

var generatedBaseTypes : bool
var m_worldSize : int
var m_chunkBaseMap : Dictionary[Vector2i, Chunk.ChunkBaseType]

var m_snowStartY : int

var m_cliff1Height : int

var m_structures : Array[Structure] = []

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
	
	GenerateStoneBiome()
	
	@warning_ignore("integer_division")
	m_cliff1Height = m_snowStartY/2
	GenerateCliff()
	
	var worldData : WorldData = WorldData.new()
	var name : String = "svet"
	worldData.worldName = name
	worldData.chunkTypeMap = m_chunkBaseMap 
	worldData.structures = m_structures
	
	ResourceSaver.save(worldData, "res://" + name + ".tres")
	
	var worldData2 = load("res://" + name + ".tres")

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
	var snowH = Global.TileType.SNOW_PATH_MIDDLE
	
	var snowDown1  = Global.TileType.SNOW_PATH_DOWN1
	var snowDown2  = Global.TileType.SNOW_PATH_DOWN2
	
	var snowUp1  = Global.TileType.SNOW_PATH_UP1
	var snowUp2  = Global.TileType.SNOW_PATH_UP2
	
	var chunksPathIsIn : Array[Vector2i] = []
	@warning_ignore("integer_division")
	for i in range(-m_worldSize/2, m_worldSize/2):
		chunksPathIsIn.append(Vector2i(i, m_snowStartY+1))
	
	var pathData : Dictionary[Vector2i, Global.TileType] = {}
	
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
	
	var snowLine : SnowLine = SnowLine.new()
	snowLine.m_chunks = chunksPathIsIn
	snowLine.m_tileData = pathData
	m_structures.append(snowLine)

func GenerateCliff():
	var cliffHstart  = Global.TileType.GRASS_CLIFF_START_TOP
	var cliffHstartDown  = Global.TileType.GRASS_CLIFF_START_BOTTOM
	
	var cliffHend  = Global.TileType.GRASS_CLIFF_END_TOP
	var cliffHendDown  = Global.TileType.GRASS_CLIFF_END_BOTTOM
	
	var cliffHmiddle  = Global.TileType.GRASS_CLIFF_MIDDLE_TOP
	var cliffHmiddleDown  = Global.TileType.GRASS_CLIFF_MIDDLE_BOTTOM
	
	var cliffDown1  = Global.TileType.GRASS_CLIFF_DOWN_1
	var cliffDown2  = Global.TileType.GRASS_CLIFF_DOWN_2
	var cliffDown3  = Global.TileType.GRASS_CLIFF_DOWN_3
	
	var cliffUp1  = Global.TileType.GRASS_CLIFF_UP_1
	var cliffUp2  = Global.TileType.GRASS_CLIFF_UP_2
	var cliffUp3  = Global.TileType.GRASS_CLIFF_UP_3
	
	var tileData : Dictionary[Vector2i, Global.TileType] = {}
	@warning_ignore("integer_division")
	var tileYPos = (m_cliff1Height + 1) * 32 - 32/2
	
	var chunksPathIsIn : Array[Vector2i] = []
	@warning_ignore("integer_division")
	for i in range(-m_worldSize/2, m_worldSize/2):
		chunksPathIsIn.append(Vector2i(i, m_cliff1Height+1))
	
	var posToSkip : int = 0
	var skipCooldown : int = 0
	var heightChangeCooldown : int = 0
	@warning_ignore("integer_division")
	for tileXPos in range(-m_worldSize/2 * 32, m_worldSize/2 * 32):
		if posToSkip > 0:
			posToSkip -= 1
			if posToSkip == 0:
				tileData[Vector2i(tileXPos, tileYPos)] = cliffHstart
				tileData[Vector2i(tileXPos, tileYPos-1)] = cliffHstartDown
				skipCooldown = 10
			continue
		
		if randi_range(1, 50) == 5 and skipCooldown == 0:
			tileData[Vector2i(tileXPos, tileYPos)] = cliffHend
			tileData[Vector2i(tileXPos, tileYPos-1)] = cliffHendDown
			
			posToSkip = randi_range(3, 10)
			continue
		
		if (randi_range(1, 10) == 5) and heightChangeCooldown == 0:
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
				
			heightChangeCooldown = 2
			continue
		
		tileData[Vector2i(tileXPos, tileYPos)] = cliffHmiddle
		tileData[Vector2i(tileXPos, tileYPos-1)] = cliffHmiddleDown
		if skipCooldown > 0:
			skipCooldown -= 1
		
		if heightChangeCooldown > 0:
			heightChangeCooldown -= 1
	
	var cliff : Cliff = Cliff.new()
	cliff.m_chunks = chunksPathIsIn
	cliff.m_tileData = tileData
	m_structures.append(cliff)

func GenerateStoneBiome():
	
	# at least 3 chunks away from center and world border, either left or right of origin
	@warning_ignore("integer_division")
	var stoneBiomePosX : int = [-1, 1].pick_random() * randi_range(3, m_worldSize/2-3)
	var stoneBiomePosY : int
	
	while true:
		@warning_ignore("integer_division")
		stoneBiomePosY = randi_range(5, m_worldSize/2 - 1)
		# 5x5 of chunks around potential position must be grass
		for x in range(-2, 3):
			for y in range(-2, 3):
				var potentialPos : Vector2i = Vector2i(stoneBiomePosX+x, stoneBiomePosY+y)
				if not (potentialPos in m_chunkBaseMap):
					continue
				if m_chunkBaseMap[potentialPos] != Chunk.ChunkBaseType.GRASS:
					continue
		print("Rock biome pos is: ", stoneBiomePosX, ", ", stoneBiomePosY)
		break
	
	var stoneBiomePos : Vector2i = Vector2i(stoneBiomePosX, stoneBiomePosY)
	
	var stack : Array = []
	var visited : Array = []
	
	var initLifeTime : int = 5
	stack.append([stoneBiomePos, initLifeTime])
	
	while not stack.is_empty():
		var value : Array = stack.pop_back()
		var position : Vector2i = value[0]
		var currLifeTime : int = value[1]
		
		if currLifeTime <= 0:
			continue
		
		if position in m_chunkBaseMap and m_chunkBaseMap[position] == Chunk.ChunkBaseType.GRASS:
			m_chunkBaseMap[position] = Chunk.ChunkBaseType.STONY
		else:
			continue
		
		for i in [-1, 0, 1]:
			for j in [-1, 0, 1]:
				var neighbour : Vector2i = Vector2i(position.x + i, position.y + j)
				if (neighbour in m_chunkBaseMap) and (not neighbour in visited):
					stack.append([neighbour, currLifeTime - randi_range(1, 3)])
		
		visited.append(position)

func GetChunkBaseMap() -> Dictionary[Vector2i, Chunk.ChunkBaseType]:
	return m_chunkBaseMap

func GetStructures() -> Array[Structure]:
	return m_structures
