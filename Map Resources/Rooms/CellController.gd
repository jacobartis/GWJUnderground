extends Area

export var topFacePath: NodePath
export var northFacePath: NodePath
export var eastFacePath: NodePath
export var southFacePath: NodePath
export var westFacePath: NodePath
export var bottomFacePath: NodePath

onready var topFace: MeshInstance = get_node(topFacePath)
onready var northFace: MeshInstance = get_node(northFacePath)
onready var eastFace: MeshInstance = get_node(eastFacePath)
onready var southFace: MeshInstance = get_node(southFacePath)
onready var westFace: MeshInstance = get_node(westFacePath)
onready var bottomFace: MeshInstance = get_node(bottomFacePath)

func update_faces(cell_list):
	var grid_position = Vector2(translation.x/Global.GRID_SIZE, translation.z/Global.GRID_SIZE)
	
	if cell_list.has(grid_position + Vector2.RIGHT):
		better_free(eastFace)
	if cell_list.has(grid_position + Vector2.LEFT):
		better_free(westFace)
	if cell_list.has(grid_position + Vector2.DOWN):
		better_free(southFace)
	if cell_list.has(grid_position + Vector2.UP):
		better_free(northFace)

func better_free(node):
	
	if !is_instance_valid(node):
		return
	node.queue_free()
