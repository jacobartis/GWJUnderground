extends Control


export var health_bar_path: NodePath 
export var health_lable_path: NodePath 

onready var health_bar: TextureProgress = get_node(health_bar_path)
onready var health_lable: Label = get_node(health_lable_path)

var health = 100

func _process(_delta):
	update_hp()

func update_hp():
	health_bar.set_max(Global.max_health)
	health_lable.set_text(str(health)+"/"+str(Global.max_health))
	health_bar.set_value(health)

func _on_Player_health_changed(new_health):
	health = new_health
