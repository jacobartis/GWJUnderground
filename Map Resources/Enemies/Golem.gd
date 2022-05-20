extends "res://Map Resources/Enemies/EnemyBase.gd"
#Sprites by Stephen "Redshrike" Challener as graphic artist and William.Thompsonj as contributor.

enum {
	WINDUP = 3
}

export var windup_time: float = .75
export var attack_range_path: NodePath 

onready var attack_range: Area = get_node(attack_range_path)

var windup_start: float = 0.0

func state_handler():
	match state:
		IDLE:
			pass
		CHASING:
			chase()
		WINDUP:
			windup()
		ATTACKING:
			attack()

func windup():
	
	if get_time()-last_attack < attack_cooldown:
		return 

	if windup_start == 0:
		move_and_slide(-transform.basis.z*move_speed*5, UP)
		windup_start = get_time()
		anim.set_frame(0)
		anim.play("Windup")
	
	if !anim.get_frame() == anim.get_sprite_frames().get_frame_count("Windup")-1:
		return
	
	if get_time()-windup_start > windup_time:
		state = ATTACKING

func attack():
	last_attack = get_time()
	
	if anim.get_animation() != "Attack":
		anim.set_frame(0)
		anim.play("Attack")
	
	if !anim.get_frame() == anim.get_sprite_frames().get_frame_count("Attack")-1:
		return
	
	if attack_range.get_overlapping_bodies().has(target):
		target.take_damage(damage)
		state = WINDUP
	else:
		state = CHASING
	
	windup_start = 0

#Checks when the player enters the attack range
func _on_AttackRangeController_body_entered(body):
	
	if !body.is_in_group("Player"):
		return
	
	if state == DEAD:
		return
	
	target = body
	state = WINDUP
