extends TileMap

export var rooms: int = 20
export var tileSet: TileSet

var rand = RandomNumberGenerator.new()
var avalibleRooms = []
var currentRooms = []

#Randomly generates the level for the set number or rooms
func generate():
	var x: int = 0
	set_cell(0,0,1)
	currentRooms.append([0,0])
	updateAvalible()
	
	for x in range(rooms):
		rand.randomize()
		var tileId: int = rand.randi_range(1,tileSet.get_tiles_ids().size())
		addRoom(avalibleRooms[rand.randi_range(0,avalibleRooms.size()-1)][0],tileId)
		updateAvalible()

#Adds a room to the generation and adds that room to current rooms
func addRoom(currentRoom, tileId):
	set_cell(avalibleRooms[currentRoom][0],avalibleRooms[currentRoom][1],tileId)
	currentRooms.append(avalibleRooms[currentRoom])

#Resets then adds all avalible rooms to the array
func updateAvalible():
	var z: int = 0
	
	avalibleRooms.clear()
	
	for z in range(currentRooms.size()):
		
		var currentRoom = currentRooms[z]
		addNoDups([(currentRoom[0]-1),(currentRoom[1])])
		addNoDups([(currentRoom[0]),(currentRoom[1]-1)])
		addNoDups([(currentRoom[0]+1),(currentRoom[1])])
		addNoDups([(currentRoom[0]),(currentRoom[1]+1)])

#Adds a room to the avalible rooms array that isn't in any other array
func addNoDups(currentRoom):
	
	if avalibleRooms.has(currentRoom):
		return
	
	if currentRooms.has(currentRoom):
		return
	
	avalibleRooms.append(currentRoom)
