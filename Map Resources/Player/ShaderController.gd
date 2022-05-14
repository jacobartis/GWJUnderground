extends ViewportContainer

const MAX_HEALTH: float = 100.0

export var light2d_path: NodePath

onready var pixelation = material.get_shader_param("pixelSize")
onready var light2d: Node = get_node(light2d_path)


func _on_Player_health_changed(new_health):
	if new_health != 0:
		pixelation = clamp((MAX_HEALTH/new_health)*1.75,4,100)
		light2d.texture_scale = clamp(float(new_health/MAX_HEALTH)*7.5,1.0,4.0)
	material.set_shader_param("pixelSize", pixelation)



func _on_Player_player_dead():
	material.set_shader_param("dead", true)


