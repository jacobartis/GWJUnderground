extends Spatial

export var attack_speed: float = 1.0
export var damage: float = 5.0

export var raycast_path: NodePath
export var anim_path: NodePath

onready var raycast: RayCast = get_node(raycast_path)
onready var anim: AnimationPlayer = get_node(anim_path)

func _ready():
	pass

func attack():
	
	if !raycast.get_collider():
		return
	
	var target = raycast.get_collider()
	
	if !target.is_in_group("Enemy"):
		return
	
	anim.play("Attack")
	target.health = clamp(target.health-damage, 0, 10000)
