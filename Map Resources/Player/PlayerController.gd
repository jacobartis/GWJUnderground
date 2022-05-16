extends KinematicBody

enum mouse_lock{
	LOCKED = 0,
	UNLOCKED = 1
}

signal health_changed(new_health)
signal mana_changed(new_mana)
signal player_dead()

export var health: float = 100.0
export var mana: float = 100.0
export var move_speed: float = 3
export var acceleration: float = 50
export var gravity: float = .25
export var mouse_sensitivity: float = 0.08

export var camera_path: NodePath
export var player_path: NodePath
export var hand_path: NodePath
export var interact_raycast_path: NodePath

onready var camera: Camera = get_node(camera_path)
onready var player: KinematicBody = get_node(player_path)
onready var weapon: Node = get_node(hand_path).get_child(0)
onready var interact_raycast: RayCast = get_node(interact_raycast_path)

onready var mouse_status = mouse_lock.LOCKED
onready var prev_health: float = health 
onready var last_attack: float = 0.0

var velocity: Vector3
var vertical_vector: Vector3

var player_in_control: bool = true

var health_potions: int = 1
var mana_potions: int = 0

func _input(event):
	aim(event)

#Handles cheking stats and actions
func _process(_delta):
	check_health()
	check_actions()

func _physics_process(delta):
	movement(delta)

#Handles player movement
func movement(delta):
	var movement_direction: Vector3 = Vector3.ZERO
	var current_speed: float = move_speed
	
	if !player_in_control:
		return
	
	if Input.is_action_pressed("move_forward"):
		movement_direction -= transform.basis.z
	elif Input.is_action_pressed("move_backward"):
		movement_direction += transform.basis.z
	
	if Input.is_action_pressed("move_left"):
		movement_direction -= transform.basis.x
	elif Input.is_action_pressed("move_right"):
		movement_direction += transform.basis.x
	
	#Sets movement vector
	movement_direction = movement_direction.normalized()
	velocity = velocity.linear_interpolate(movement_direction*current_speed, acceleration * delta)
	velocity = move_and_slide(velocity, Vector3.UP)
	
	#changes camera position
	camera.global_transform.origin = player.global_transform.origin+(Vector3.UP*.5)

#Handles moving the camera with the mouse
func aim(event):
	var mouse_motion = event as InputEventMouseMotion
	
	if !player_in_control:
		return
	
	if !mouse_motion:
		return
	
	if mouse_status != mouse_lock.LOCKED:
		return
	
	var current_tilt = camera.rotation_degrees.x
	camera.rotation_degrees.y -= mouse_motion.relative.x * mouse_sensitivity
	current_tilt -= mouse_motion.relative.y * mouse_sensitivity
	camera.rotation_degrees.x = clamp(current_tilt, -90, 90)
	player.rotation_degrees.y = camera.rotation_degrees.y

 #Checks if health is changed or if the player dies
func check_health():
	
	if Global.healing > 0:
		heal(Global.healing)
		Global.healing = 0
	
	#Makes sure player health can't go above max
	if health > Global.max_health:
		health = Global.max_health
	
	#checks if the players health has changed
	if health == prev_health:
		return
	
	#Checks if the players is dead
	if !health > 0:
		emit_signal("player_dead")
		player_in_control = false
	
	#Sends the signal to update the displays for health
	prev_health = health
	emit_signal("health_changed",health)

#Updates the players health when healing (or taking damage from own attacks)
func heal(healing):
	health = clamp(health + healing, 1, Global.max_health)

#Updates the players health when taking damage from enemies
func take_damage(damage):
	health -= clamp(damage - Global.armour, 0, health)

#Checks the avalible player actions
func check_actions():
	
	if !player_in_control == true:
		return
	healing()
	attacking()
	interacting()

#Handles the attack inputs of the player
func attacking():
	
	#Checks if the player can and wants to attack
	if !Input.is_action_pressed("attack"):
		return
	
	if get_time()-last_attack < weapon.attack_speed:
		return
	
	#Updates last attack timer
	last_attack = get_time()
	
	#Attacks with weapon and checks if an enemy is hit
	if weapon.attack(Global.damage_change, Global.damage_multiplier):
		#If an enemy is hit, applys life on hit to hp
		heal(Global.life_on_hit)

#Handles the player interacting with objects
func interacting():
	
	#Checks the player wants to interact and with what
	if !Input.is_action_just_pressed("interact"):
		return
	
	if !interact_raycast.get_collider():
		return
	
	var target = interact_raycast.get_collider()
	
	if !target.is_in_group("Interactable"):
		return
	
	#Runs the interact func of the interactable object
	target.interact()

func healing():
	
	if !Input.is_action_just_pressed("heal"):
		return
	
	if !health_potions > 0:
		return
	
	heal(50)
	health_potions -= 1 

#Used for cooldowns
func get_time():
	return OS.get_ticks_msec()/1000.0
