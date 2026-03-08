class_name Chunk
extends RefCounted

const CHUNK_SIZE : int = 32

class TerrainTileData:
	var m_srcId : int
	var m_attlassCoords : Vector2i

class DecorationTileData:
	pass

class EntityTileData:
	pass

enum ChunkBaseType {
	GRASS,
	RIVER_H1,
	RIVER_H2,
	RIVER_H_UP1,
	RIVER_H_UP2,
	RIVER_H_DOWN1,
	RIVER_H_DOWN2,
	RIVER_V1,
	RIVER_CONNECTOR
}

var m_baseType : ChunkBaseType
var m_terrainTiles : Dictionary[Vector2i, TerrainTileData]
var m_decorationTiles : Dictionary[Vector2i, DecorationTileData]
var m_entityTiles : Dictionary[Vector2i, EntityTileData]

func _init(baseType, terrainTiles, decorationTiles, entityTiles) -> void:
	m_baseType = baseType
	m_terrainTiles = terrainTiles
	#m_decorationTiles = decorationTiles
	#m_entityTiles = entityTiles

static func FromFile(filePath : String) -> Chunk:
	return null

func GetTileAt(pos : Vector2i) -> TerrainTileData:
	return m_terrainTiles[pos]
