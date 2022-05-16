extends Control


export var mana_bar_path: NodePath 
export var mana_lable_path: NodePath 

onready var mana_bar: TextureProgress = get_node(mana_bar_path)
onready var mana_lable: Label = get_node(mana_lable_path)



func _on_Player_mana_changed(new_mana):
	mana_bar.set_max(Global.max_mana)
	mana_bar.set_value(new_mana)
	mana_lable.set_text(str(new_mana)+"/"+str(Global.max_mana))
