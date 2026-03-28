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
	
	# WATER
	WATER,
	
	WATER_GRASS_START_TOP,
	WATER_GRASS_MIDDLE_TOP,
	WATER_GRASS_END_TOP,
	
	WATER_GRASS_LEFT,
	WATER_GRASS_RIGHT,
	
	WATER_GRASS_START_BOTTOM,
	WATER_GRASS_MIDDLE_BOTTOM,
	WATER_GRASS_END_BOTTOM,
	
	WATER_GRASS_ISLAND_TOP_LEFT,
	WATER_GRASS_ISLAND_TOP_RIGHT,
	WATER_GRASS_ISLAND_BOTTOM_LEFT,
	WATER_GRASS_ISLAND_BOTTOM_RIGHT,
	
	# stone
	STONE
}

enum DecorationTileTypes {
	PETALS_1,
	PETALS_2,
	PETALS_3,
	PETALS_4,
	TALL_GRASS,
	ROSE,
	SNOWY_TALL_GRASS,
	ROCK_1,
	ROCK_2,
	ROCK_3,
	ROCK_4,
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
	
	TileType.WATER : {TileSrcID : 3, TileAttlassCoords : Vector2i(5, 1) },
	
	TileType.WATER_GRASS_START_TOP : {TileSrcID : 3, TileAttlassCoords : Vector2i(4, 0) },
	TileType.WATER_GRASS_MIDDLE_TOP : {TileSrcID : 3, TileAttlassCoords : Vector2i(5, 0) },
	TileType.WATER_GRASS_END_TOP : {TileSrcID : 3, TileAttlassCoords : Vector2i(6, 0) },
	
	TileType.WATER_GRASS_LEFT : {TileSrcID : 3, TileAttlassCoords : Vector2i(4, 1) },
	TileType.WATER_GRASS_RIGHT : {TileSrcID : 3, TileAttlassCoords : Vector2i(6, 1) },
	
	TileType.WATER_GRASS_START_BOTTOM : {TileSrcID : 3, TileAttlassCoords : Vector2i(4, 2) },
	TileType.WATER_GRASS_MIDDLE_BOTTOM : {TileSrcID : 3, TileAttlassCoords : Vector2i(5, 2) },
	TileType.WATER_GRASS_END_BOTTOM : {TileSrcID : 3, TileAttlassCoords : Vector2i(6, 2) },
	
	TileType.WATER_GRASS_ISLAND_TOP_LEFT : {TileSrcID : 3, TileAttlassCoords : Vector2i(4, 3) },
	TileType.WATER_GRASS_ISLAND_TOP_RIGHT : {TileSrcID : 3, TileAttlassCoords : Vector2i(5, 3) },
	TileType.WATER_GRASS_ISLAND_BOTTOM_LEFT : {TileSrcID : 3, TileAttlassCoords : Vector2i(4, 4) },
	TileType.WATER_GRASS_ISLAND_BOTTOM_RIGHT : {TileSrcID : 3, TileAttlassCoords : Vector2i(5, 4) },
	TileType.STONE : {TileSrcID : 3, TileAttlassCoords : Vector2i(7, 0) }
}

const DecorationTileTypeData : Dictionary = {
	DecorationTileTypes.PETALS_1 : {TileSrcID : 0, TileAttlassCoords : Vector2i(0, 0) },
	DecorationTileTypes.PETALS_2 : {TileSrcID : 0, TileAttlassCoords : Vector2i(1, 0) },
	DecorationTileTypes.PETALS_3 : {TileSrcID : 0, TileAttlassCoords : Vector2i(2, 0) },
	DecorationTileTypes.PETALS_4 : {TileSrcID : 0, TileAttlassCoords : Vector2i(3, 0) },
	DecorationTileTypes.TALL_GRASS : {TileSrcID : 0, TileAttlassCoords : Vector2i(0, 1) },
	DecorationTileTypes.ROSE : {TileSrcID : 0, TileAttlassCoords : Vector2i(3, 1) },
	DecorationTileTypes.SNOWY_TALL_GRASS : {TileSrcID : 0, TileAttlassCoords : Vector2i(0, 4) },
	DecorationTileTypes.ROCK_1 : {TileSrcID : 0, TileAttlassCoords : Vector2i(0, 3) },
	DecorationTileTypes.ROCK_2 : {TileSrcID : 0, TileAttlassCoords : Vector2i(1, 3) },
	DecorationTileTypes.ROCK_3 : {TileSrcID : 0, TileAttlassCoords : Vector2i(2, 3) },
	DecorationTileTypes.ROCK_4 : {TileSrcID : 0, TileAttlassCoords : Vector2i(3, 3) }
}

const SaveDirectory : StringName = "res://saves/"
