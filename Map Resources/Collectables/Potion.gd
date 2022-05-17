extends Spatial

enum{
	HEALTH,
	MANA
}

export var type = HEALTH

func pickup(player):
	match type:
		HEALTH:
			player.health_potions += 1
		MANA:
			player.mana_potions += 1

func _on_Area_body_entered(body):
	
	if !body.is_in_group("Player"):
		return
	
	pickup(body)
	queue_free()
