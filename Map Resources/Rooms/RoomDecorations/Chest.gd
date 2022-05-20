extends Area

var spawn_preload = preload("res://Map Resources/Collectables/HealthPotion.tscn")

var opened: bool = false

func interact():
	
	if opened == true:
		return
	
	var spawn = spawn_preload.instance()
	get_parent().add_child(spawn)
	spawn.global_transform = global_transform
	spawn.translate(Vector3(0,1.2,0))
	
	opened = true
