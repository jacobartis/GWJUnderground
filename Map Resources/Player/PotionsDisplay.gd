extends Control

export var healing_label_path: NodePath
export var mana_label_path: NodePath

onready var healing_label: Label = get_node(healing_label_path)
onready var mana_label: Label = get_node(mana_label_path)

func _on_Player_healing_potions(new_healing_potions):
	healing_label.set_text(("Healing potions: "+str(new_healing_potions)))


func _on_Player_mana_potions(new_mana_potions):
	mana_label.set_text(("Mana potions: "+str(new_mana_potions)))
