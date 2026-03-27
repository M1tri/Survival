class_name WorldData
extends Resource

@export var worldName : String
@export var worldSize : int
@export var chunkTypeMap : Dictionary[Vector2i, Chunk.ChunkBaseType]
@export var structures : Array[Structure]
