extends KinematicBody

const UP = Vector3.UP

enum{
	IDLE,
	CHASING,
	ATTACKING
}

export var attack_cooldown: float = 1.0
export var damage: int = 5
export var health: int = 10
export var move_speed: float = 1.0
export var anim_path: NodePath
export var eyes_path: NodePath

onready var anim: AnimationPlayer = get_node(anim_path)
onready var eyes: Spatial = get_node(eyes_path)
onready var state = IDLE

var target: Node
var last_attack: float = 0.0

func _process(_delta):
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

#Handles chasing after the player
func chase():
	eyes.look_at(target.global_transform.origin*Vector3(1,0,1), Vector3.UP)
	rotate_y(deg2rad(eyes.rotation.y*20))
	
	anim.play("Walk")
	
	move_and_slide(-transform.basis.z*move_speed, UP)

#Handles attacking
func attack():
	
	if get_time()-last_attack < attack_cooldown:
		return 
	
	last_attack = get_time()
	anim.play("Attack")
	target.health = clamp(target.health-damage, 0 ,1000)

func check_health():
	
	if !health == 0:
		return
	
	queue_free()

#Checks when the player enters the detection area
func _on_DetectionController_body_entered(body):
	
	if !body.is_in_group("Player"):
		return
	
	target = body
	state = CHASING

#Checks when the player leaves the dectection area
func _on_DetectionController_body_exited(body):
	
	if !body.is_in_group("Player"):
		return
	
	if !state == CHASING:
		return
	
	target = null
	state = IDLE

#Checks when the player enters the attack range
func _on_AttackRangeController_body_entered(body):
	
	if !body.is_in_group("Player"):
		return
	target = body
	state = ATTACKING

#Checks when the player leaves the attack range
func _on_AttackRangeController_body_exited(body):
	
	if !body.is_in_group("Player"):
		return
	
	state = CHASING

func get_time():
	return OS.get_ticks_msec()/1000.0
