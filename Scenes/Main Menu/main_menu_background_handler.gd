extends Panel
var background_one = preload("res://Graphics/Backgrounds/menu_background_one.png")
var background_two = preload("res://Graphics/Backgrounds/menu_background_two.png")

var background_stylebox = preload("res://Scenes/Main Menu/main_menu_background_stylebox.tres")

func _ready():
	var backgrounds = [background_one, background_two]
	background_stylebox.set("texture", backgrounds.pick_random())
	pass
