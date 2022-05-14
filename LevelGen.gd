#Used a base of HeartBeast's 3D dungeon code to generate the dungeon from a map
#Youtube: https://www.youtube.com/watch?v=6yqObNCkiiY&t=65s #
#GitHub: https://github.com/uheartbeast/3d-dungeon

extends Spatial

const CELL = preload("res://Map Resources/Rooms/Cell.tscn")

export var mapScene: PackedScene

var cells = []

func _ready():
	generate_map()

func generate_map():
	if !mapScene is PackedScene: return
	var map = mapScene.instance()
	var tileMap = map.get_tilemap()
	var used_tiles = tileMap.get_used_cells()
	map.free() # We don't need it now that we have the tile data
	for tile in used_tiles:
		var cell = CELL.instance()
		add_child(cell)
		cell.translation = Vector3(tile.x*Global.GRID_SIZE, 0, tile.y*Global.GRID_SIZE)
		cells.append(cell)
	for cell in cells:
		cell.update_faces(used_tiles)



