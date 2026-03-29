class_name SnowLine
extends Structure

func IsInChunk(chunkPos : Vector2i) -> bool:
	for chunk in m_chunks:
		if chunk == chunkPos:
			return true
	return false

func PlaceInChunk(chunkPos : Vector2i, chunkData : Dictionary[Vector2i, Global.TileType]):
	var snow : Global.TileType = Global.TileType.SNOW
	
	for chunkLocal in chunkData:
		var tileGlobal : Vector2i = CoordinateConverter.ChunkLocalToTileGlobal(chunkLocal, chunkPos)
		
		if m_tileData.has(tileGlobal):
			chunkData[chunkLocal] = m_tileData[tileGlobal]
			var verticalColumn : Vector2i = Vector2i(chunkLocal.x, chunkLocal.y-1)
			if m_tileData[tileGlobal] == Global.TileType.SNOW_PATH_DOWN2\
			 or m_tileData[tileGlobal] == Global.TileType.SNOW_PATH_UP1:
				continue
			while (verticalColumn in chunkData):
				chunkData[verticalColumn] = snow
				verticalColumn.y -= 1
