extends TileMap

export var tileSet: TileSet

var rand = RandomNumberGenerator.new()
var avalibleRooms = []
var currentRooms = []
var furthest =[0,0]

var enemy_count = 0
var max_enemies = 0

#Randomly generates the level for the set number or rooms
func generate(rooms):
	#Clears current map
	clear()
	#Sets the initial cell at 0,0 and updates avalible rooms
	start_area()
	currentRooms.append([0,0])
	updateAvalible()
	
	max_enemies = rooms/4
	enemy_count = 0
	
	#Iterates for the required number of rooms
	for _x in range(rooms):
		rand.randomize()
		
		#Sets the next type of tile
		var tileId = get_enemy(Global.level)
		
		#Adds a room to a random position in avalible rooms
		addRoom(avalibleRooms[rand.randi_range(0,avalibleRooms.size()-1)][0],tileId)
		#Updates avalible rooms
		updateAvalible()
	
	
	#Finaly adds the exit at potentialy furthest spot
	addRoom(avalibleRooms[avalibleRooms.find(furthest,0)][0],2)
	updateAvalible()
	#Adds chests
	addRoom(avalibleRooms[rand.randi_range(0,avalibleRooms.size()-1)][0],get_chest())
	updateAvalible()

func start_area():
	set_cell(0,0,1)
	currentRooms.append([0,0])
	set_cell(1,0,1)
	currentRooms.append([1,0])
	set_cell(-1,0,1)
	currentRooms.append([-1,0])
	set_cell(0,1,1)
	currentRooms.append([0,1])
	set_cell(0,-1,1)
	currentRooms.append([0,-1])
	set_cell(1,1,1)
	currentRooms.append([1,1])
	set_cell(1,-1,1)
	currentRooms.append([1,-1])
	set_cell(-1,1,1)
	currentRooms.append([-1,1])
	set_cell(-1,-1,1)
	currentRooms.append([-1,-1])

#roomStylesList = CELL, CELL_EXIT, CELL_GOBLIN, CELL_SKELETON, CELL_SPIDER, CELL_GOLEM, CELL_CHEST
func get_enemy(level):
	var type = 1
	var spawn = rand.randi_range(0,100)
	
	if enemy_count == max_enemies:
		return type
	
	enemy_count += 1
	
	if !spawn>50:
		type = 3
	if !spawn>30 && !level < 5:
		type = 4
	if !spawn>20 && !level < 10:
		type = 5
	if !spawn>10 && !level < 15:
		type = 6
	
	return type

func get_chest():
	var spawn = rand.randi_range(0,100)
	if !spawn<50:
		return 7
	return 1

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
