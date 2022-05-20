extends KinematicBody

const UP = Vector3.UP
const DELETE_DELAY = 1

const POTION = preload("res://Map Resources/collectables/HealthPotion.tscn")

enum{
	IDLE,
	CHASING,
	ATTACKING,
	DEAD
}

#Sets the base stats of the enemy
export var attack_cooldown: float = 1.0
export var base_damage: int = 5 
export var base_health: int = 10 
export var base_points: int = 100 
export var move_speed: float = 1.0

#Gets the path to the required nodes
export var anim_path: NodePath
export var eyes_path: NodePath
export var hitbox_path: NodePath

#Gets the required nodes from their path
onready var anim: AnimatedSprite3D = get_node(anim_path)
onready var eyes: Spatial = get_node(eyes_path)
onready var hitbox: CollisionShape = get_node(hitbox_path)

#Sets the initial state
onready var state = IDLE

#Sets the actual stats based on the level
onready var multiplier = Global.get_enemy_mult()
onready var damage: int = base_damage * multiplier
onready var health: int = base_health * multiplier
onready var points: int = base_points * multiplier

var rand = RandomNumberGenerator.new()

var target: Node
var last_attack: float = 0.0
var death_time: float

func _process(_delta):
	check_health()
	state_handler()


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
	
	if !target && state != DEAD:
		state = IDLE
		return
	
	eyes.look_at(target.global_transform.origin*Vector3(1,0,1), Vector3.UP)
	rotate_y(deg2rad(eyes.rotation.y*20))
	
	anim.play("Walk")
	
	move_and_slide(-transform.basis.z*move_speed, UP)

#Handles attacking
func attack():
	
	if get_time()-last_attack < attack_cooldown:
		return 
	
	#Sets the last attack to now and resets the animation
	if anim.get_animation() != "Attack" || anim.get_frame()==0:
		anim.set_frame(0)
		anim.play("Attack")
	
	if !anim.get_frame() == anim.get_sprite_frames().get_frame_count("Attack")-1:
		return
	
	last_attack = get_time()
	anim.set_frame(0)
	
	target.take_damage(damage)

func check_health():
	
	if health > 0:
		return
	
	if !state == DEAD:
		anim.play("Death")
		death_time = get_time()
		hitbox.set_disabled(true)
		Global.points += points
	
	state = DEAD
	if !anim.get_frame() == anim.get_sprite_frames().get_frame_count("Death")-1:
		return
	
	if get_time()-death_time < DELETE_DELAY:
		return
	spawn_potion()
	queue_free()

func spawn_potion():
	var potion = POTION.instance()
	rand.randomize()
	if !rand.randi_range(0,100)>10:
		print(2)
		get_tree().root.get_child(2).add_child(potion)#
		potion.global_transform = global_transform

#Checks when the player enters the detection area
func _on_DetectionController_body_entered(body):
	
	if !body.is_in_group("Player"):
		return
	
	if state == DEAD:
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
	
	if state == DEAD:
		return
	
	target = body
	state = ATTACKING

#Checks when the player leaves the attack range
func _on_AttackRangeController_body_exited(body):
	
	if !body.is_in_group("Player"):
		return
	
	if state == DEAD:
		return
	
	state = CHASING

func get_time():
	return OS.get_ticks_msec()/1000.0
