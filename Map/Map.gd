extends Node2D

export var tileMapPath: NodePath

func get_tilemap():
	var tileMap: TileMap = get_node(tileMapPath)
	tileMap.generate()
	return tileMap

