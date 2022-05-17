extends Spatial

export var attack_speed: float = 1.0
export var damage: float = 5.0

export var raycast_path: NodePath
export var anim_path: NodePath

onready var raycast: RayCast = get_node(raycast_path)
onready var anim: AnimationPlayer = get_node(anim_path)

func attack(damage_change, damage_multiplier):
	
	anim.play("Attack")
	
	#Checks if enemy is hit
	if !raycast.get_collider():
		return false
	
	var target = raycast.get_collider()
	
	if !target.is_in_group("Enemy"):
		return false
	
	#Damaged enemy
	target.health = clamp(target.health-((damage+damage_change)*damage_multiplier), 0, 10000)
	
	#Retruns that an enemy was hit
	return true
