extends Panel
var asteroid_refinery_background = preload("res://Graphics/Backgrounds/asteroid_refinery_background.png")
var scrapyard_background = preload("res://Graphics/Backgrounds/scrapyard_background.png")
var fleet_background = preload("res://Graphics/Backgrounds/fleet_background.png")
var trade_route_background = preload("res://Graphics/Backgrounds/trade_route_background1.png")

var background_stylebox = preload("res://Scenes/Map Select/background_stylebox.tres")

func update(map_identifier: String):
	match map_identifier:
		"asteroid_refinery":
			background_stylebox.set("texture", asteroid_refinery_background)
		"scrapyard":
			background_stylebox.set("texture", scrapyard_background)
		"fleet":
			background_stylebox.set("texture", fleet_background)
		"trade_route":
			background_stylebox.set("texture", trade_route_background)
		_:
			background_stylebox.set("texture", null)
	pass
