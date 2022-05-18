extends Spatial

var points: int = 1000

func interact():
	Global.points += clamp(points/(get_time()/2), 100, 1000)
	Global.level += 1
	print(Global.level%5)
	if Global.level%5==0:
		Global.trade_points += 1
	Global.loaded = false
	Global.need_to_generate = true

func get_time():
	return OS.get_ticks_msec()/1000.0
