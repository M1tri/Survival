class_name CoordinateConverter
extends RefCounted

const CHUNK_SIZE : int = 32

static func TileGlobalToChunkLocal(tilePos : Vector2i) -> Vector2i:
	return Vector2i(posmod(tilePos.x, CHUNK_SIZE), posmod(tilePos.y, CHUNK_SIZE))

static func ChunkLocalToTileGlobal(inChunkPos : Vector2i, chunkPos : Vector2i) -> Vector2i:
	return Vector2i(chunkPos.x * CHUNK_SIZE + inChunkPos.x, chunkPos.y * CHUNK_SIZE - inChunkPos.y)
