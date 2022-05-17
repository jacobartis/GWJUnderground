extends TileMap

export var tileSet: TileSet

var rand = RandomNumberGenerator.new()
var avalibleRooms = []
var currentRooms = []
var furthest =[0,0]

#Randomly generates the level for the set number or rooms
func generate(rooms):
	#Clears current map
	clear()
	#Sets the initial cell at 0,0 and updates avalible rooms
	set_cell(0,0,1)
	currentRooms.append([0,0])
	updateAvalible()
	
	#Iterates for the required number of rooms
	for _x in range(rooms):
		rand.randomize()
		
		#Sets the next type of tile
		var tileId: int = 1
		
		#Adds a room to a random position in avalible rooms
		addRoom(avalibleRooms[rand.randi_range(0,avalibleRooms.size()-1)][0],tileId)
		#Updates avalible rooms
		updateAvalible()
	
	#Finaly adds the exit at potentialy furthest spot
	addRoom(avalibleRooms[avalibleRooms.find(furthest,0)][0],4)

#Adds a room to the generation map and adds that room to current rooms
func addRoom(currentRoom, tileId):
	set_cell(avalibleRooms[currentRoom][0],avalibleRooms[currentRoom][1],tileId)
	currentRooms.append(avalibleRooms[currentRoom])

#Resets then adds all avalible rooms to the array
func updateAvalible():
	
	avalibleRooms.clear()
	
	#Adds all directly adjacent rooms to avalible rooms for every current room
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
	
	#Check for the furthest room in the list
	if compare(currentRoom,furthest):
		furthest = currentRoom

#Algorithm for comparing distance
func compare(a, b):
	var x = 0
	var y = 0
	
	if a[0] < 0:
		x = -a[0]
	else:
		x = a[0]
	if a[1] < 0:
		x += -a[1]
	else:
		x += a[1]
	
	if b[0] < 0:
		y = -b[0]
	else:
		y = b[0]
	if b[1] < 0:
		y += -b[1]
	else:
		y += b[1]
	
	if x > y || x == y:
		return true
	return false
