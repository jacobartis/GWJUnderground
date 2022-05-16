extends Node2D

export var tileMapPath: NodePath

func get_tilemap():
	var tileMap: TileMap = get_node(tileMapPath)
	var rooms = clamp(5*Global.level, 0 ,150)
	tileMap.generate(rooms)
	return tileMap
