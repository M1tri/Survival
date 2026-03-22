class_name Global
extends Node

enum TileType {
	# GRASS
	GRASS,
	
	GRASS_CLIFF_START_TOP,
	GRASS_CLIFF_MIDDLE_TOP,
	GRASS_CLIFF_END_TOP,
	GRASS_CLIFF_START_BOTTOM,
	GRASS_CLIFF_MIDDLE_BOTTOM,
	GRASS_CLIFF_END_BOTTOM,
	
	GRASS_CLIFF_UP_1,
	GRASS_CLIFF_UP_2,
	GRASS_CLIFF_UP_3,
	
	GRASS_CLIFF_DOWN_1,
	GRASS_CLIFF_DOWN_2,
	GRASS_CLIFF_DOWN_3,
	
	# SNOW
	SNOW,
	
	SNOW_CLIFF_START_TOP,
	SNOW_CLIFF_MIDDLE_TOP,
	SNOW_CLIFF_END_TOP,
	SNOW_CLIFF_START_BOTTOM,
	SNOW_CLIFF_MIDDLE_BOTTOM,
	SNOW_CLIFF_END_BOTTOM,
	
	SNOW_CLIFF_UP_1,
	SNOW_CLIFF_UP_2,
	SNOW_CLIFF_UP_3,
	
	SNOW_CLIFF_DOWN_1,
	SNOW_CLIFF_DOWN_2,
	SNOW_CLIFF_DOWN_3,
	
	SNOW_PATH_MIDDLE,
	
	SNOW_PATH_DOWN1,
	SNOW_PATH_DOWN2,
	
	SNOW_PATH_UP1,
	SNOW_PATH_UP2,
}

const TileSrcID : String = "srcId"
const TileAttlassCoords : String = "attlass_coords"

const TileTypeData : Dictionary = {
	TileType.GRASS : {TileSrcID : 3, TileAttlassCoords : Vector2i(0, 0) },
	
	TileType.GRASS_CLIFF_START_TOP : {TileSrcID : 3, TileAttlassCoords : Vector2i(1, 0) },
	TileType.GRASS_CLIFF_MIDDLE_TOP : {TileSrcID : 3, TileAttlassCoords : Vector2i(2, 0) },
	TileType.GRASS_CLIFF_END_TOP : {TileSrcID : 3, TileAttlassCoords : Vector2i(3, 0) },
	TileType.GRASS_CLIFF_START_BOTTOM : {TileSrcID : 3, TileAttlassCoords : Vector2i(1, 1) },
	TileType.GRASS_CLIFF_MIDDLE_BOTTOM : {TileSrcID : 3, TileAttlassCoords : Vector2i(2, 1) },
	TileType.GRASS_CLIFF_END_BOTTOM : {TileSrcID : 3, TileAttlassCoords : Vector2i(3, 1) },
	
	TileType.GRASS_CLIFF_UP_1 : {TileSrcID : 3, TileAttlassCoords : Vector2i(3, 2) },
	TileType.GRASS_CLIFF_UP_2 : {TileSrcID : 3, TileAttlassCoords : Vector2i(3, 3) },
	TileType.GRASS_CLIFF_UP_3 : {TileSrcID : 3, TileAttlassCoords : Vector2i(3, 4) },
	
	TileType.GRASS_CLIFF_DOWN_1 : {TileSrcID : 3, TileAttlassCoords : Vector2i(1, 2) },
	TileType.GRASS_CLIFF_DOWN_2 : {TileSrcID : 3, TileAttlassCoords : Vector2i(1, 3) },
	TileType.GRASS_CLIFF_DOWN_3 : {TileSrcID : 3, TileAttlassCoords : Vector2i(1, 4) },
	
	# SNOW
	TileType.SNOW : {TileSrcID : 3, TileAttlassCoords : Vector2i(9, 0) },
	
	TileType.SNOW_CLIFF_START_TOP : {TileSrcID : 3, TileAttlassCoords : Vector2i(10, 0) },
	TileType.SNOW_CLIFF_MIDDLE_TOP : {TileSrcID : 3, TileAttlassCoords : Vector2i(11, 0) },
	TileType.SNOW_CLIFF_END_TOP : {TileSrcID : 3, TileAttlassCoords : Vector2i(12, 0) },
	TileType.SNOW_CLIFF_START_BOTTOM : {TileSrcID : 3, TileAttlassCoords : Vector2i(10, 1) },
	TileType.SNOW_CLIFF_MIDDLE_BOTTOM : {TileSrcID : 3, TileAttlassCoords : Vector2i(11, 1) },
	TileType.SNOW_CLIFF_END_BOTTOM : {TileSrcID : 3, TileAttlassCoords : Vector2i(12, 1) },
	
	TileType.SNOW_CLIFF_UP_1 : {TileSrcID : 3, TileAttlassCoords : Vector2i(12, 2) },
	TileType.SNOW_CLIFF_UP_2 : {TileSrcID : 3, TileAttlassCoords : Vector2i(12, 3) },
	TileType.SNOW_CLIFF_UP_3 : {TileSrcID : 3, TileAttlassCoords : Vector2i(12, 4) },
	
	TileType.SNOW_CLIFF_DOWN_1 : {TileSrcID : 3, TileAttlassCoords : Vector2i(10, 2) },
	TileType.SNOW_CLIFF_DOWN_2 : {TileSrcID : 3, TileAttlassCoords : Vector2i(10, 3) },
	TileType.SNOW_CLIFF_DOWN_3 : {TileSrcID : 3, TileAttlassCoords : Vector2i(10, 4) },
	
	TileType.SNOW_PATH_MIDDLE : {TileSrcID : 3, TileAttlassCoords : Vector2i(14, 0) },
	TileType.SNOW_PATH_DOWN1 : {TileSrcID : 3, TileAttlassCoords : Vector2i(13, 0) },
	TileType.SNOW_PATH_DOWN2 : {TileSrcID : 3, TileAttlassCoords : Vector2i(13, 1) },
	TileType.SNOW_PATH_UP1 : {TileSrcID : 3, TileAttlassCoords : Vector2i(15, 1) },
	TileType.SNOW_PATH_UP2 : {TileSrcID : 3, TileAttlassCoords : Vector2i(15, 0) },
}
