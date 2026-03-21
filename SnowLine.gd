class_name SnowLine
extends Structure

func _init(tileData : Dictionary[Vector2i, Chunk.TerrainTileData], chunks : Array[Vector2i]) -> void:
	m_tileData = tileData
	m_chunks = chunks

func IsInChunk(chunkPos : Vector2i) -> bool:
	for chunk in m_chunks:
		if chunk == chunkPos:
			return true
	return false

func PlaceInChunk(chunkPos : Vector2i, chunkData : Dictionary[Vector2i, Chunk.TerrainTileData]):
	var snow : Chunk.TerrainTileData = Chunk.TerrainTileData.new()
	snow.m_srcId = 3
	snow.m_attlassCoords = Vector2i(9, 0)
	
	for chunkLocal in chunkData:
		var tileGlobal : Vector2i = CoordinateConverter.ChunkLocalToTileGlobal(chunkLocal, chunkPos)
		
		if m_tileData.has(tileGlobal):
			chunkData[chunkLocal] = m_tileData[tileGlobal]
			var verticalColumn : Vector2i = Vector2i(chunkLocal.x, chunkLocal.y-1)
			if m_tileData[tileGlobal].m_attlassCoords == Vector2i(15, 1) or m_tileData[tileGlobal].m_attlassCoords == Vector2i(13, 1):
				continue
			while (verticalColumn in chunkData):
				chunkData[verticalColumn] = snow
				verticalColumn.y -= 1
