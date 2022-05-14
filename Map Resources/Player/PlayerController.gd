extends KinematicBody

enum mouse_lock{
	LOCKED = 0,
	UNLOCKED = 1
}

signal health_changed(new_health)
signal player_dead()

export var health: float = 100.0
export var move_speed: float = 3
export var acceleration: float = 50
export var gravity: float = .25
export var mouse_sensitivity: float = 0.08

export var camera_path: NodePath
export var player_path: NodePath
export var Hand_path: NodePath

onready var camera: Node = get_node(camera_path)
onready var player: Node = get_node(player_path)
onready var weapon: Node = get_node(Hand_path).get_child(0)

onready var mouse_status = mouse_lock.LOCKED
onready var prev_health: float = health 
onready var last_attack: float = 0.0

var velocity: Vector3
var vertical_vector: Vector3



var player_in_control: bool = true

func _input(event):
	aim(event)

func _process(_delta):
	check_health()
	check_actions()

func _physics_process(delta):
	movement(delta)

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
	camera.global_transform.origin = player.global_transform.origin+(Vector3.UP*.25)

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

#Handles mouse mode operations
func mouse_mode():
	#Swaps the mouse mode if the toggle_mouse button is pressed
	if Input.is_action_just_pressed("toggle_mouse"):
		mouse_status = (mouse_status + 1)%2
	
	#Checks the current mouse status and sets the mode accordingly
	match mouse_status:
		mouse_lock.LOCKED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
			if !health > 0:
				return
			player_in_control = true
		
		mouse_lock.UNLOCKED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			player_in_control = false
 
func check_health():
	
	if health == prev_health:
		return
	
	if health == 0:
		emit_signal("player_dead")
		player_in_control = false
	
	prev_health = health
	emit_signal("health_changed",health)

func check_actions():
	mouse_mode()
	attack()
	interact()

func attack():
	
	if !Input.is_action_pressed("attack"):
		return
	
	if get_time()-last_attack < weapon.attack_speed:
		return
	
	last_attack = get_time()
	weapon.attack()

func interact():
	
	if !Input.is_action_just_pressed("interact"):
		return
	
	

func get_time():
	return OS.get_ticks_msec()/1000.0
