extends "res://Map Resources/Enemies/EnemyBase.gd"
#Sprites by Stephen "Redshrike" Challener as graphic artist and William.Thompsonj as contributor.

const RANGED_COOLDOWN = 5
const RANGED_RECOVERY = .75

export var projectile = preload("res://Map Resources/Enemies/Projectiles/WebShot.tscn")
export var aim_path: NodePath
export var attack_range_path: NodePath

export var base_webbed_duration: float = 5

onready var world: Node = get_tree().root.get_child(2)
onready var aim: RayCast = get_node(aim_path)
onready var attack_range: Area = get_node(attack_range_path)
onready var webbed_duration: float = base_webbed_duration*multiplier

var prev_ranged_attack: float = 0
var recovering: bool = false

enum {
	RANGED_ATTACK=4
}

#Handles state checks
func _process(_delta):
	#Checks if the enemy should do a ranged attack
	check_ranged_attack()
	#Checks if enemy is dead
	check_health()
	#Handles the states
	state_handler()

#Handles states
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
	
	#Checks attack cooldown
	if get_time()-last_attack < attack_cooldown:
		return 
	
	#Sets the last attack to now and resets the animation
	if anim.get_animation() != "Attack" || anim.get_frame()==0:
		anim.set_frame(0)
		anim.play("Attack")
	
	if !anim.get_frame() == anim.get_sprite_frames().get_frame_count("Attack")-1:
		return
	
	#If the player is webbed they take 4x damage
	if target.webbed:
		target.take_damage(damage*4)
	else:
		target.take_damage(damage)
	
	anim.set_frame(0)
	last_attack = get_time()

#Handles chasing the player
func chase():
	#Direction
	eyes.look_at(target.global_transform.origin*Vector3(1,0,1), Vector3.UP)
	rotate_y(deg2rad(eyes.rotation.y*20))
	
	#Plays the animation
	anim.play("Walk")
	
	#If the player is webbed the enemy speeds up
	if target.webbed:
		move_speed = 1.25
	else:
		move_speed = 0.5
	
	#Moves the enemy
	move_and_slide(-transform.basis.z*move_speed, UP)

func check_ranged_attack():
	
	if !target:
		return
	
	if state==DEAD:
		return
	
	if attack_range.get_overlapping_bodies().has(target):
		return
	
	if target.webbed:
		return
	
	if get_time() - prev_ranged_attack < RANGED_COOLDOWN:
		return
	
	state = RANGED_ATTACK

func ranged_attack():
	
	if !target:
		return
	
	if recovering:
		return
	
	if anim.get_animation() != "RangedAttack":
		anim.set_frame(0)
		anim.play("RangedAttack")
	
	if !anim.get_frame() == anim.get_sprite_frames().get_frame_count("RangedAttack")-1:
		return
	
	var shot_instance = projectile.instance()
	
	eyes.look_at(target.global_transform.origin*Vector3(1,1,1), Vector3.UP)
	
	world.add_child(shot_instance)
	shot_instance.global_transform = eyes.global_transform
	
	shot_instance.set_damage(damage/2)
	shot_instance.set_web_duration(damage/2)
	
	prev_ranged_attack = get_time()
	
	recovering = true
	create_timer(RANGED_RECOVERY)

func create_timer(time):
	var timer = Timer.new()
	timer.connect("timeout",self,"_on_timer_timeout") 
	add_child(timer)
	timer.set_wait_time(time)
	timer.start() 

func _on_RangedAttackController_body_entered(body):
	
	if !body.is_in_group("Player"):
		return
	
	if body.webbed:
		return
	
	if !state == CHASING:
		return
	
	target = body

func _on_timer_timeout():
	
	if state != RANGED_ATTACK:
		return
	
	if !attack_range.get_overlapping_bodies().has(target):
		state = CHASING
	
	recovering = false
