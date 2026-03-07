class_name ChunkData
extends RefCounted

enum ChunkType {Grass=0, River=1}

var m_type : ChunkType
var m_tiles : Dictionary

func _init(type : ChunkType, tiles : Dictionary) -> void:
	m_type = type
	m_tiles = tiles

func ToFile(filePath : String) -> bool:
	var file = FileAccess.open(filePath, FileAccess.WRITE)
	if (file == null):
		return false
	
	var data = {
		"type" : m_type,
		"tiles" : m_tiles
	}
	
	var data_json = JSON.stringify(data, "\t")
	file.store_string(data_json)
	
	file.close()
	
	return true

static func FromFile(filePath : String) -> ChunkData:
	var file = FileAccess.open(filePath, FileAccess.READ)
	var text = file.get_as_text()
	var decoded = JSON.parse_string(text)
	
	var tiles = decoded["tiles"]
	var tile_data = {}
	for tile in tiles:
		var pos = ParseVecFromStr(tile)
		var attlas_coords = ParseVecFromStr(tiles[tile][1])
		tile_data[pos] = [tiles[tile][0], attlas_coords]
	
	return ChunkData.new(decoded["type"], tile_data)

static func ParseVecFromStr(input : String) -> Vector2i:
	var cleaned = input.replace("(", "").replace(")", "")
	var parts = cleaned.split(",")
	var x = int(parts[0])
	var y = int(parts[1])
	return Vector2i(x, y)
