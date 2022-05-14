#Used a base of HeartBeast's 3D dungeon code to generate the dungeon from a map
#Youtube: https://www.youtube.com/watch?v=6yqObNCkiiY&t=65s #
#GitHub: https://github.com/uheartbeast/3d-dungeon

extends Spatial

const CELL = preload("res://Map Resources/Rooms/Cell.tscn")
const CELL2 = preload("res://Map Resources/Rooms/Cell2.tscn")

export var mapScene: PackedScene
export var tileSet: TileSet

onready var roomList: = [CELL, CELL2]

var cells = []

func _ready():
	generate_map()

func generate_map():
	if !mapScene is PackedScene: return
	var map = mapScene.instance()
	var tileMap = map.get_tilemap()
	var tileId: int = 0
	
	for tileId in range(tileSet.get_tiles_ids().size()):
		
		var used_tiles = tileMap.get_used_cells_by_id(tileId)
		
		for tile in used_tiles:
			var cell = roomList[tileId-1].instance()
			add_child(cell)
			cell.translation = Vector3(tile.x*Global.GRID_SIZE, 0, tile.y*Global.GRID_SIZE)
			cells.append(cell)
		
		for cell in cells:
			cell.update_faces(used_tiles)



