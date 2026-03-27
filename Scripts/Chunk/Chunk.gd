class_name Chunk
extends RefCounted

const CHUNK_SIZE : int = 32

class TerrainTileData:
	var m_type : Global.TileType
	var m_srcId : int
	var m_attlassCoords : Vector2i
	
	static func MakeNew(type : Global.TileType) -> TerrainTileData:
		var ret = TerrainTileData.new()
		
		ret.m_type = type
		ret.m_srcId = Global.TileTypeData[type][Global.TileSrcID]
		ret.m_attlassCoords = Global.TileTypeData[type][Global.TileAttlassCoords]
		
		return ret
	
	func IsEqual(type : Global.TileType):
		return self.m_type == type

class DecorationTileData:
	var m_type : Global.DecorationTileTypes
	var m_srcId : int
	var m_attlassCoords : Vector2i
	
	static func MakeNew(type : Global.DecorationTileTypes) -> DecorationTileData:
		var ret = DecorationTileData.new()
		
		ret.m_type = type
		ret.m_srcId = Global.DecorationTileTypeData[type][Global.TileSrcID]
		ret.m_attlassCoords = Global.DecorationTileTypeData[type][Global.TileAttlassCoords]
		
		return ret
	
	func IsEqual(type : Global.TileType):
		return self.m_type == type

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
	RIVER_CONNECTOR,
	SNOW,
	STONY
}

var m_baseType : ChunkBaseType
var m_terrainTiles : Dictionary[Vector2i, TerrainTileData]
var m_decorationTiles : Dictionary[Vector2i, DecorationTileData]
var m_entityTiles : Dictionary[Vector2i, EntityTileData]

func _init(baseType, terrainTiles, decorationTiles, entityTiles) -> void:
	m_baseType = baseType
	m_terrainTiles = terrainTiles
	m_decorationTiles = decorationTiles
	#m_entityTiles = entityTiles

static func FromFile(resourcePath : String) -> Chunk:
	var resource : ChunkSaveResource = load(resourcePath) as ChunkSaveResource 
	
	var tiles : Dictionary[Vector2i, TerrainTileData] = {}
	for tileType in resource.tileData:
		tiles[tileType] = TerrainTileData.MakeNew(resource.tileData[tileType])
	
	return Chunk.new(resource.baseType, tiles, {}, {})

func SaveToFile(resourcePath : String):
	var resource : ChunkSaveResource = ChunkSaveResource.new()
	
	for tile in m_terrainTiles:
		resource.tileData[tile] = m_terrainTiles[tile].m_type
	resource.baseType = m_baseType
	
	ResourceSaver.save(resource, resourcePath)

func GetTileAt(pos : Vector2i) -> TerrainTileData:
	return m_terrainTiles[pos]
