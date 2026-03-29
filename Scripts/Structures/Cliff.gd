class_name Cliff
extends Structure

func IsInChunk(chunkPos : Vector2i) -> bool:
	for chunk in m_chunks:
		if chunk == chunkPos:
			return true
	return false

func PlaceInChunk(chunkPos : Vector2i, chunkData : Dictionary[Vector2i, Global.TileType]):
	var snow : Chunk.TerrainTileData = Chunk.TerrainTileData.new()
	snow.m_srcId = 3
	snow.m_attlassCoords = Vector2i(9, 0)
	
	for chunkLocal in chunkData:
		var tileGlobal : Vector2i = CoordinateConverter.ChunkLocalToTileGlobal(chunkLocal, chunkPos)
		
		if m_tileData.has(tileGlobal):
			chunkData[chunkLocal] = m_tileData[tileGlobal]
