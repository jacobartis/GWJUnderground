extends Node

#Size of grid cells
const GRID_SIZE = 2

#The core varibles of the game
var need_to_generate: bool = false
var level: int = 1
var loaded: bool = true
var points: int = 0
var trade_points: int = 0

var player = null

#Player stats given by trades
var healing: int = 0
var damage_change: int = 0
var damage_multiplier: float = 1.0
var max_health: int = 100
var max_mana: int = 100
var armour: int = 0
var sight_range: int = 6
var life_on_hit: int = 0

var spells = []

#enemy stats based on levels
func get_enemy_mult():
	return clamp((float(level)*2.0)/5,1,1000)

