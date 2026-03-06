extends Node

@onready var terrainTileLayer = $TerrainTileLayer

@export var startX : int
@export var startY : int
@export var file_name : String

func _ready() -> void:
	LoadTileData()

func SaveTileData():
	var tilemap_data = []
	
	for i in range(startX, startX+32):
		for j in range(startY, startY+32):
			var cell = Vector2i(i, j)
			var srcId = terrainTileLayer.get_cell_source_id(cell)
			var attlas_coords = terrainTileLayer.get_cell_atlas_coords(cell)
			tilemap_data.append([cell, srcId, attlas_coords])
	
	var filePath = "res://" + file_name + ".dat"
	
	var file = FileAccess.open(filePath, FileAccess.WRITE)
	file.store_string(JSON.stringify(tilemap_data))
	file.close()
	print("Napisano na " + filePath)

func _on_button_pressed() -> void:
	SaveTileData()

const files = ["riverH_down1", "riverH_up1","riverV_down1","riverV_down2","riverV_up1","riverV_up2",]
const riverPath = "res://Data/Chunks/River/"

func LoadTileData():
	var xPos = 0
	
	for fileName in files:
		var filePath = riverPath + fileName + ".dat"
		var file = FileAccess.open(filePath, FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())
		
		var x = 0
		var y = 0
		for cell in data:
			var pos = ParseVecFromStr(cell[0])
			var src_id = cell[1]
			var attlas_coord = ParseVecFromStr(cell[2])
			
			print(pos)
			print(src_id)
			print(attlas_coord)
			
			terrainTileLayer.set_cell(Vector2i(xPos + x, y), src_id, attlas_coord)
			
			y += 1
			if (y > 31):
				y = 0
				x += 1
		
		xPos = xPos + 33

func ParseVecFromStr(input : String) -> Vector2i:
	var cleaned = input.replace("(", "").replace(")", "")
	var parts = cleaned.split(",")
	var x = int(parts[0])
	var y = int(parts[1])
	return Vector2i(x, y)
