@abstract
class_name Structure
extends RefCounted

var m_tileData : Dictionary[Vector2i, Chunk.TerrainTileData]
var m_chunks : Array[Vector2i]

@abstract
func IsInChunk(chunkPos : Vector2i) -> bool

@abstract
func PlaceInChunk(chunkPos : Vector2i, chunkData : Dictionary[Vector2i, Chunk.TerrainTileData])
