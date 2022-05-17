extends ViewportContainer



export var light2d_path: NodePath
export var enviroment: Environment

onready var pixelation = material.get_shader_param("pixelSize")
onready var light2d: Light2D = get_node(light2d_path)

var max_health: float = 100.0

var sight = Global.sight_range

func _process(_delta):
	check_fog()

func check_fog():
	sight = Global.sight_range
	if enviroment.get_fog_depth_end() == sight:
		return
	
	enviroment.set_fog_depth_end(sight)

func _on_Player_health_changed(new_health):
	max_health = Global.max_health
	
	pixelation = clamp((max_health/(new_health+1))*1.75,4,100)+1
	light2d.texture_scale = clamp(float(new_health/(max_health+1))*7.5,1.0,4.0)
	
	if !new_health > 0:
		pixelation = 50
		light2d.texture_scale = 1
	
	material.set_shader_param("pixelSize", pixelation)





func _on_Player_player_dead():
	material.set_shader_param("dead", true)


