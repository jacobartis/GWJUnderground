extends RigidBody

const LIFE_TIME = 3

export var move_speed: float = .25

var damage = 0.0

onready var spawn_time = get_time()

func _ready():
	pass 

func _process(_delta):
	check_despawn()
	move()

func check_despawn():
	
	if get_time()-spawn_time<LIFE_TIME:
		return
	
	queue_free()

func set_damage(new_damage):
	damage = new_damage

func set_move_speed(new_move_speed):
	move_speed = new_move_speed

#Used for despawning
func get_time():
	return OS.get_ticks_msec()/1000.0

func move():
	apply_impulse(transform.basis.z, -transform.basis.z * move_speed) 

func _on_Area_body_entered(body):
	if !body.is_in_group("Player"):
		return
	queue_free()
	body.health = clamp(body.health-(damage), 0, 10000)

