extends TileMap

export var rooms: int = 10

var rand = RandomNumberGenerator.new()
var avalibleRooms = []

func generate():
	set_cell(0,0,1)
