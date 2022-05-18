extends Control

enum type {
	DAMAGE = 0,
	DAMAGE_MULTI = 1,
	HEALTH = 2,
	ARMOUR = 3,
	SIGHT = 4,
	LIFE_ON_HIT = 5,
	SPELLS = 6,
	FILTERS = 7,
	HEALING = 8,
	MANA = 9
}

enum {
	TAKEN = 0,
	NAME = 1,
	DESCRIPTION = 2,
	FLOOR_REQUIREMENT = 3,
	GAIN_TYPE = 4,
	GAIN = 5,
	COST_TYPE = 6,
	COST = 7
}

const PLACEHOLDER = "brother"

export var avalible_trades_path: NodePath
export var description_path: NodePath
export var confirmation_path: NodePath
export var error_path: NodePath

onready var description: RichTextLabel = get_node(description_path)
onready var avalible_trades: ItemList = get_node(avalible_trades_path)
onready var trade_confirmation: ConfirmationDialog = get_node(confirmation_path)
onready var trade_error: ConfirmationDialog = get_node(error_path)

var trades_index = null
var avalible_trades_index = null

#Trades, stored in form (Taken, Name, Desciption, FloorRequirement, Gain_type, Gain_amount, Cost_type, Cost_amount)
#Costs and Gains are stored as:
#DAMAGE = 0, DAMAGE_MULTI = 1, HEALTH = 2, ARMOUR = 3, SIGHT = 4, LIFE_ON_HIT = 5, SPELLS = 6, 
#FILTERS = 7,HEALING = 8,MANA = 9
#Healing doubles as a flat health cost, Can only set player to 1 hp
var trades = [[false,"Name1","Damage for health",5,0,5,2,20],[false,"Name2","Damage multi for sight",5,1,1.5,4,3],
[false,"Name3","Health for Damage multi",5,2,50,1,.25],[false,"Name4","Healing for damage",5,8,100,0,3],
[false,"Name5","Large Damage for low hp",10,0,100,2,Global.max_health-1]]

#Displays the trades based on floor number
func _ready():
	update()

func update():
	avalible_trades.clear()
	for x in trades.size():
		if trades[x][FLOOR_REQUIREMENT] > Global.level:
			pass
		elif !trades[x][TAKEN] == false:
			pass
		else:
			avalible_trades.add_item(str(trades[x][NAME]))
			avalible_trades.set_item_metadata(avalible_trades.get_item_count()-1,x)

#If an option is chosen it displays the description
func _process(_delta):
	
	if visible == false:
		return
	
	if trades_index==null:
		return
	
	if trades_index < 0:
		return
	
	set_description()

#Handles setting the description
func set_description():
	description.clear()
	description.add_text(str(trades[trades_index][DESCRIPTION]))


#Applys the effect of the taken trade
func make_trade():
	apply_effect(trades[trades_index][COST_TYPE], -trades[trades_index][COST])
	apply_effect(trades[trades_index][GAIN_TYPE], trades[trades_index][GAIN])
	trades[trades_index][TAKEN] = true
	avalible_trades.remove_item(avalible_trades_index)
	description.clear()
	description.add_text(PLACEHOLDER)


#Checks the effect type and applys that effect
func apply_effect(effect_type, amount):
	match effect_type:
		type.DAMAGE:
			Global.damage_change += amount
		type.DAMAGE_MULTI:
			Global.damage_multiplier += amount
		type.HEALTH:
			Global.max_health += amount
			Global.healing += amount
		type.ARMOUR:
			Global.armour += amount
		type.SIGHT:
			Global.sight_range += amount
		type.LIFE_ON_HIT:
			Global.life_on_hit += amount
		type.SPELLS:
			pass
		type.FILTERS:
			pass
		type.HEALING:
			Global.healing += amount
		type.MANA:
			Global.max_mana += amount

#Updates the current selection 
func _on_AvalibleTrades_item_selected(index):
	avalible_trades_index = index
	trades_index = avalible_trades.get_item_metadata(index)

#Checks if an item was double clicked and shows a confirmation box
func _on_AvalibleTrades_item_activated(_index):
	if Global.trade_points > 0:
		trade_confirmation.show()
	else:
		trade_error.show()

#Applys the confirmed trade
func _on_TradeConfirmation_confirmed():
	Global.trade_points -= 1
	make_trade()

func _on_TradeMenuController_draw():
	update()
