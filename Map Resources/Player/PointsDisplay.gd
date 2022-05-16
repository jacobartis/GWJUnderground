extends Control

export var points_path: NodePath

onready var point_label: Label = get_node(points_path)

var current_points = -1

func _process(delta):
	update_points()

func update_points():
	
	if Global.points == current_points:
		return
	
	current_points = Global.points
	point_label.set_text(("Points: "+str(current_points)))
