#Used a base of HeartBeast's 3D dungeon code to generate the dungeon from a map
#Youtube: https://www.youtube.com/watch?v=6yqObNCkiiY&t=65s #
#GitHub: https://github.com/uheartbeast/3d-dungeon

extends Spatial

const CELL = preload("res://Map Resources/Rooms/Cell.tscn")
const CELL_LIGHT_NS = preload("res://Map Resources/Rooms/CellLightNS.tscn")
const CELL_LIGHT_EW = preload("res://Map Resources/Rooms/CellLightEW.tscn")
const CELL_EXIT = preload("res://Map Resources/Rooms/CellExit.tscn")

export var mapScene: PackedScene
export var tileSet: TileSet
export var levelNodePath: NodePath
export var playerPath: NodePath

onready var roomStylesList: = [CELL,CELL_LIGHT_NS,CELL_LIGHT_EW,CELL_EXIT]
onready var levelNode:Spatial = get_node(levelNodePath)
onready var player: KinematicBody = get_node(playerPath)

var cells = []
var start

func _ready():
	generate_map()

func _process(_delta):
	
	if Global.need_to_generate == false:
		return
	
	Global.need_to_generate = false
	generate_map()
	player.set_translation(Vector3(0,player.translation.y,0))

func generate_map():
	if !mapScene is PackedScene: return
	var map = mapScene.instance()
	var tileMap = map.get_tilemap()
	var total_tiles: Array = []
	
	cells.clear()
	
	for x in range(levelNode.get_child_count()):
		levelNode.get_child(x).queue_free()
	
	#Iterates over the tile set to get the different room style locations
	for tileId in range(tileSet.get_tiles_ids().size()+1):
		
		#Gets placement of the current style of rooms
		var used_tiles = tileMap.get_used_cells_by_id(tileId)
		
		#Iterates over the current rooms
		for tile in used_tiles:
			
			#Makes an instance of the current room style
			var cell = roomStylesList[tileId-1].instance()
			#Places that cell
			levelNode.add_child(cell)
			#Changes the position of that cell
			cell.translation = Vector3(tile.x*Global.GRID_SIZE, 0, tile.y*Global.GRID_SIZE)
			#Adds that to the list of cells
			cells.append(cell)
		

		
		#Adds all values of used_tiles to total_tiles
		for x in range(used_tiles.size()):
			total_tiles.append(used_tiles[x])
	
	update(total_tiles)

func update(total_tiles):
	
	for cell in cells:
		if is_instance_valid(cell):
			cell.update_faces(total_tiles)
		
