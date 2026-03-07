extends Node

@onready var player = $Player

@onready var terrainTileLayer = $TerrainTileLayer

@export var startX : int
@export var startY : int
@export var file_name : String

func _ready() -> void:
	LoadTileData()

func _process(_delta: float) -> void:
	print("Global pos: " + str(player.global_position))
	print("Chunk pos: " + str(floor(player.global_position/1024)))
	print("Tile pos: " + str(floor(player.global_position/32)))
	var tile_pos = floor(player.global_position/32)
	var local_chunk_pos = Vector2i(posmod(tile_pos.x, 32), posmod(tile_pos.y, 32))
	print("Local chunk pos: " + str(local_chunk_pos))

const riverPath = "res://Data/Chunks/River/"

const river = {
	Vector2i(5, 0) : "riverH_down1",
	Vector2i(4, 0) : "riverH_up1",
	Vector2i(3, 0) : "riverV_down1",
	Vector2i(3, 1) : "riverV_down2",
	Vector2i(2, 1) : "riverH_up1",
	Vector2i(1, 1) : "riverH_down1",
	Vector2i(0, 1) : "riverV_up1",
	Vector2i(0, 0) : "riverV_up2",
	Vector2i(-1, 0) : "riverH_down1",
	Vector2i(-2, 0) : "riverH_up1"
}

func LoadTileData():
	for chunkPos in river:
		var filePath = riverPath + river[chunkPos] + ".dat"
		var chunkData = ChunkData.FromFile(filePath)
		PlaceChunkAt(chunkPos, chunkData)

func PlaceChunkAt(chunkPos : Vector2i, chunkData : ChunkData):
	var globalTileXPos = chunkPos.x * 32
	var globlTileYPos = chunkPos.y * 32
	
	for cell in chunkData.m_tiles:
		var data = chunkData.m_tiles[cell]
		terrainTileLayer.set_cell(Vector2i(cell.x + globalTileXPos, cell.y + globlTileYPos), data[0], data[1])
