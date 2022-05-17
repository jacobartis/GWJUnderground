extends Spatial

export var projectile = preload("res://Map Resources/Weapons/RangedWeapons/Ammo/AmmoBase.tscn")
export var aim_path: NodePath
export var anim_path: NodePath

export var attack_speed: float = 1.0
export var damage: float = 5.0

onready var aim: RayCast = get_node(aim_path)
onready var anim: AnimationPlayer = get_node(anim_path)
onready var world: Node = get_tree().root.get_child(0)

func attack(damage_change, damage_multiplier):
	var shot_instance = projectile.instance()
	
	if !aim.is_colliding():
		return
	
	world.add_child(shot_instance)
	shot_instance.global_transform = get_parent().global_transform
	shot_instance.translate(Vector3(0,.125,.125))
	shot_instance.look_at(aim.get_collision_point(), Vector3.UP)
	shot_instance.set_damage((damage+damage_change)*damage_multiplier)
	
	#Doesnt give on hit effects
	return false
