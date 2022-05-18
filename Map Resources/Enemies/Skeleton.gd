extends "res://Map Resources/Enemies/EnemyBase.gd"

const RANGED_COOLDOWN = 5

export var projectile = preload("res://Map Resources/Enemies/Projectiles/Bone.tscn")
export var aim_path: NodePath

onready var world: Node = get_tree().root.get_child(0)
onready var aim: RayCast = get_node(aim_path)

var can_ranged: bool = false
var prev_ranged_attack: float = 0

enum {
	RANGED_ATTACK
}

func _ready():
	health = 150
	points = 200
	move_speed = 0.5

func _process(_delta):
	check_ranged_attack()
	state_handler()
	check_health()
	

func state_handler():
	match state:
		IDLE:
			pass
		CHASING:
			chase()
		ATTACKING:
			attack()
		RANGED_ATTACK:
			ranged_attack()

#Handles attacking
func attack():
	if get_time()-last_attack < attack_cooldown:
		return 
	
	last_attack = get_time()
	anim.set_frame(0)
	anim.play("Attack")
	target.take_damage(damage)

func check_ranged_attack():
	
	if can_ranged == false:
		return
	
	if get_time() - prev_ranged_attack < RANGED_COOLDOWN:
		return
	
	state = RANGED_ATTACK

func ranged_attack():
	var shot_instance = projectile.instance()
	
	world.add_child(shot_instance)
	shot_instance.global_transform = get_parent().global_transform
	shot_instance.translate(Vector3(0,.125,.125))
	shot_instance.look_at(aim.get_collision_point(), Vector3.UP)
	shot_instance.set_damage(damage)

func _on_RangedAttackController_body_entered(body):
	
	if body.is_in_group("Player"):
		return
	
	if health > 10:
		return
	
	target = body
	can_ranged = true
