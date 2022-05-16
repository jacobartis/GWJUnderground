extends CanvasLayer

enum mouse_lock{
	LOCKED = 0,
	UNLOCKED = 1
}

enum {
	PAUSE,
	TRADE,
	LOADING,
	NONE
}

export var pause_path: NodePath
export var trade_path: NodePath

onready var pause_menu: CanvasLayer = get_node(pause_path)
onready var trade_menu: CanvasLayer = get_node(trade_path)

var mouse_status = mouse_lock.LOCKED
var status = NONE

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

#Checks requrements for both menus
func _input(event):
	check_pause(event)
	check_trade(event)

#Checks if the game should be paused
func check_pause(event):
	
	if !(status == NONE || status == PAUSE):
		return
	
	if !event.is_action_pressed("ui_pause"):
		return
	
	#Makes the mouse visible, shows the pause menu, and pauses the tree
	mouse_mode()
	show_menu(pause_menu)
	get_tree().paused = !get_tree().paused
	
	match status:
		NONE:
			status = PAUSE
		PAUSE:
			status = NONE

#Checks if the trade menu should be shown
func check_trade(event):
	
	if !(status == NONE || status == TRADE):
		return
	
	if !event.is_action_pressed("ui_trade"):
		return
	
	#Makes the mouse visible, shows the trade menu, and pauses the tree
	mouse_mode()
	show_menu(trade_menu)
	get_tree().paused = !get_tree().paused
	
	match status:
		NONE:
			status = TRADE
		TRADE:
			status = NONE

func mouse_mode():
	#Swaps the mouse mode if the toggle_mouse button is pressed
	mouse_status = (mouse_status + 1)%2
	
	#Checks the current mouse status and sets the mode accordingly
	match mouse_status:
		mouse_lock.LOCKED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
		mouse_lock.UNLOCKED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

#Iterates through the children of the given menu and toggles visibility
func show_menu(menu):
	for x in range(menu.get_child_count()):
		menu.get_child(x).visible = !menu.get_child(x).visible

