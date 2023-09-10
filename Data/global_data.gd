extends Node

var player_name: String
var player_latest_score_id: String

var test_map_best_time: float
var scrapyard_best_time: float
var asteroid_refinery_best_time: float

func _ready():
	load_player_data()
	
	SilentWolf.configure({
		"api_key": "t17Djp2d1z8Ji8tZGVYNH63HNmxrwsAS5C6RT8tv",
		"game_id": "lunar-front",
		"log_level": 0,
	})
	
	pass

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_player_data()
	pass

func get_best_time_current_map():
	match map_data.map_identifier:
		"test_map":
			return test_map_best_time
		"asteroid_refinery":
			return asteroid_refinery_best_time
		"scrapyard":
			return scrapyard_best_time
		_:
			return 0

func set_best_time_current_map(time: float):
	match map_data.map_identifier:
		"test_map":
			test_map_best_time = time
		"asteroid_refinery":
			asteroid_refinery_best_time = time
		"scrapyard":
			scrapyard_best_time = time
		_:
			return

func get_medal_current_map():
	var time = get_best_time_current_map()
	if time > 0:
		match map_data.map_identifier:
			"test_map":
				return null
			"asteroid_refinery":
				return null
			"scrapyard":
				if time > 50:
					return load("res://Graphics/Medals/bronze_medal.png")
				if time <= 50 and time >= 45:
					return load("res://Graphics/Medals/iron_medal.png")
				if time < 45:
					return load("res://Graphics/Medals/gold_medal.png")
			_:
				return null
	else:
		return null

func save_player_data():
	var file = FileAccess.open("user://saved_best_times.save", FileAccess.WRITE)
	file.store_var(player_name)
	file.store_var(test_map_best_time)
	file.store_var(scrapyard_best_time)
	file.store_var(asteroid_refinery_best_time)
	file.store_var(player_latest_score_id)
	file.close()
	pass

func load_player_data():
	if FileAccess.file_exists("user://saved_best_times.save"):
		var file = FileAccess.open("user://saved_best_times.save", FileAccess.READ)
		player_name = file.get_var(true)
		test_map_best_time = file.get_var(true)
		scrapyard_best_time = file.get_var(true)
		asteroid_refinery_best_time = file.get_var(true)
		player_latest_score_id = file.get_var(true)
		file.close()
	else:
		player_name = ""
		test_map_best_time = 0
		scrapyard_best_time = 0
		asteroid_refinery_best_time = 0
		player_latest_score_id = ""
	pass

func reset_player_data():
	var file = FileAccess.open("user://saved_best_times.save", FileAccess.WRITE)
	file.close()
	
	player_name = ""
	test_map_best_time = 0
	scrapyard_best_time = 0
	asteroid_refinery_best_time = 0
	player_latest_score_id = ""
	pass

func get_randi(from: int, to: int):
	return RandomNumberGenerator.new().randi_range(from, to)

func get_randf(from: float, to: float):
	return RandomNumberGenerator.new().randf_range(from, to)
