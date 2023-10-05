extends Node

var player_name: String

var scrapyard_best_time: float
var asteroid_refinery_best_time: float
var fleet_best_time: float
var trade_route_best_time: float

var scrapyard_par_times = [70, 50, 45]
var asteroid_refinery_par_times = [60, 45, 35]
var fleet_par_times = [70, 60, 55]
var trade_route_par_times = [60, 55, 45]

@onready var bronze_medal = preload("res://Graphics/Medals/bronze_medal.png")
@onready var iron_medal = preload("res://Graphics/Medals/iron_medal.png")
@onready var gold_medal = preload("res://Graphics/Medals/gold_medal.png")
@onready var no_medal = preload("res://Graphics/Medals/no_medal.png")

func _ready():
	load_player_data()
	settings.load_settings()
	
	SilentWolf.configure({
		"api_key": "t17Djp2d1z8Ji8tZGVYNH63HNmxrwsAS5C6RT8tv",
		"game_id": "lunar-front",
		"log_level": 0,
	})
	
	if player_name.is_empty():
		get_tree().change_scene_to_file("res://Scenes/Name Setting/name_setting.tscn")
	pass

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_player_data()
		get_tree().quit()
	pass

func get_best_time_current_map():
	match map_data.map_identifier:
		"scrapyard":
			return scrapyard_best_time
		"asteroid_refinery":
			return asteroid_refinery_best_time
		"fleet":
			return fleet_best_time
		"trade_route":
			return trade_route_best_time
		_:
			return 0

func get_best_time_from_map(map: String):
	match map:
		"scrapyard":
			return scrapyard_best_time
		"asteroid_refinery":
			return asteroid_refinery_best_time
		"fleet":
			return fleet_best_time
		"trade_route":
			return trade_route_best_time
		_:
			return 0

func set_best_time_current_map(time: float):
	match map_data.map_identifier:
		"scrapyard":
			scrapyard_best_time = time
		"asteroid_refinery":
			asteroid_refinery_best_time = time
		"fleet":
			fleet_best_time = time
		"trade_route":
			trade_route_best_time = time
		_:
			return

func get_medal_current_map():
	var time = get_best_time_current_map()
	if time > 0:
		match map_data.map_identifier:
			"scrapyard":
				if time > scrapyard_par_times[0]:
					return no_medal
				if time > scrapyard_par_times[1] and time < scrapyard_par_times[0]:
					return bronze_medal
				if time <= scrapyard_par_times[1] and time >= scrapyard_par_times[2]:
					return iron_medal
				if time < scrapyard_par_times[2]:
					return gold_medal
			"asteroid_refinery":
				if time > asteroid_refinery_par_times[0]:
					return no_medal
				if time > asteroid_refinery_par_times[1] and time < asteroid_refinery_par_times[0]:
					return bronze_medal
				if time <= asteroid_refinery_par_times[1] and time >= asteroid_refinery_par_times[2]:
					return iron_medal
				if time < asteroid_refinery_par_times[2]:
					return gold_medal
			"fleet":
				if time > fleet_par_times[0]:
					return no_medal
				if time > fleet_par_times[1] and time < fleet_par_times[0]:
					return bronze_medal
				if time <= fleet_par_times[1] and time >= fleet_par_times[2]:
					return iron_medal
				if time < fleet_par_times[2]:
					return gold_medal
			"trade_route":
				if time > trade_route_par_times[0]:
					return no_medal
				if time > trade_route_par_times[1] and time < trade_route_par_times[0]:
					return bronze_medal
				if time <= trade_route_par_times[1] and time >= trade_route_par_times[2]:
					return iron_medal
				if time < trade_route_par_times[2]:
					return gold_medal
			_:
				return null
	else:
		return no_medal
	pass

func get_medal_from_map(map: String):
	var time = get_best_time_from_map(map)
	if time > 0:
		match map:
			"scrapyard":
				if time > scrapyard_par_times[0]:
					return no_medal
				if time > scrapyard_par_times[1] and time < scrapyard_par_times[0]:
					return bronze_medal
				if time <= scrapyard_par_times[1] and time >= scrapyard_par_times[2]:
					return iron_medal
				if time < scrapyard_par_times[2]:
					return gold_medal
			"asteroid_refinery":
				if time > asteroid_refinery_par_times[0]:
					return no_medal
				if time > asteroid_refinery_par_times[1] and time < asteroid_refinery_par_times[0]:
					return bronze_medal
				if time <= asteroid_refinery_par_times[1] and time >= asteroid_refinery_par_times[2]:
					return iron_medal
				if time < asteroid_refinery_par_times[2]:
					return gold_medal
			"fleet":
				if time > fleet_par_times[0]:
					return no_medal
				if time > fleet_par_times[1] and time < fleet_par_times[0]:
					return bronze_medal
				if time <= fleet_par_times[1] and time >= fleet_par_times[2]:
					return iron_medal
				if time < fleet_par_times[2]:
					return gold_medal
			"trade_route":
				if time > trade_route_par_times[0]:
					return no_medal
				if time > trade_route_par_times[1] and time < trade_route_par_times[0]:
					return bronze_medal
				if time <= trade_route_par_times[1] and time >= trade_route_par_times[2]:
					return iron_medal
				if time < trade_route_par_times[2]:
					return gold_medal
			_:
				return null
	else:
		return no_medal
	pass

func get_medal_int_from_map(map: String):
	var time = get_best_time_from_map(map)
	if time > 0:
		match map:
			"scrapyard":
				if time > scrapyard_par_times[0]:
					return 0
				if time > scrapyard_par_times[1] and time < scrapyard_par_times[0]:
					return 1
				if time <= scrapyard_par_times[1] and time >= scrapyard_par_times[2]:
					return 2
				if time < scrapyard_par_times[2]:
					return 3
			"asteroid_refinery":
				if time > asteroid_refinery_par_times[0]:
					return 0
				if time > asteroid_refinery_par_times[1] and time < asteroid_refinery_par_times[0]:
					return 1
				if time <= asteroid_refinery_par_times[1] and time >= asteroid_refinery_par_times[2]:
					return 2
				if time < asteroid_refinery_par_times[2]:
					return 3
			"fleet":
				if time > fleet_par_times[0]:
					return 0
				if time > fleet_par_times[1] and time < fleet_par_times[0]:
					return 1
				if time <= fleet_par_times[1] and time >= fleet_par_times[2]:
					return 2
				if time < fleet_par_times[2]:
					return 3
			"trade_route":
				if time > trade_route_par_times[0]:
					return 0
				if time > trade_route_par_times[1] and time < trade_route_par_times[0]:
					return 1
				if time <= trade_route_par_times[1] and time >= trade_route_par_times[2]:
					return 2
				if time < trade_route_par_times[2]:
					return 3
			_:
				return 0
	else:
		return 0
	pass

func save_player_data():
	var file = FileAccess.open("user://cosmic_time_trials_player_data.save", FileAccess.WRITE)
	file.store_var(player_name)
	file.store_var(scrapyard_best_time)
	file.store_var(asteroid_refinery_best_time)
	file.store_var(fleet_best_time)
	file.store_var(trade_route_best_time)
	file.close()
	pass

func load_player_data():
	if FileAccess.file_exists("user://cosmic_time_trials_player_data.save"):
		var file = FileAccess.open("user://cosmic_time_trials_player_data.save", FileAccess.READ)
		player_name = file.get_var(true)
		scrapyard_best_time = file.get_var(true)
		asteroid_refinery_best_time = file.get_var(true)
		fleet_best_time = file.get_var(true)
		trade_route_best_time = file.get_var(true)
		file.close()
	else:
		player_name = ""
		scrapyard_best_time = 0
		asteroid_refinery_best_time = 0
		fleet_best_time = 0
		trade_route_best_time = 0
	pass

func reset_player_data():
	var file = FileAccess.open("user://cosmic_time_trials_player_data.save", FileAccess.WRITE)
	file.close()
	
	player_name = ""
	scrapyard_best_time = 0
	asteroid_refinery_best_time = 0
	fleet_best_time = 0
	trade_route_best_time = 0
	pass

func get_randi(from: int, to: int):
	return RandomNumberGenerator.new().randi_range(from, to)

func get_randf(from: float, to: float):
	return RandomNumberGenerator.new().randf_range(from, to)
