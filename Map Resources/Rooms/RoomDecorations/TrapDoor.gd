extends Spatial

var points: int = 5000

func interact():
	Global.points += clamp(points/(get_time()/10), 500, 1000)
	Global.level += 1
	if Global.level%5==0:
		Global.trade_points += 1
	Global.loaded = false
	Global.need_to_generate = true

func get_time():
	return OS.get_ticks_msec()/1000.0
