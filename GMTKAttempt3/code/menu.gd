extends Control

func _ready() -> void:
	$Credits.visible = false
	
	var children = []
	for child in $LevelButtons.get_children():
		for sub_child in child.get_children():
			children.append(sub_child)
	for i in range(children.size()):
		children[i].pressed.connect(_on_start_button_pressed.bind(i))
		
		children[i].text = str(i+1)
		
		var normal = load("res://themes/incomplete_normal.tres")
		var pressed = load("res://themes/incomplete_pressed.tres")
		if Globals.levels[i] == true:
			normal = load("res://themes/completed_normal.tres")
			pressed = load("res://themes/completed_pressed.tres")
			children[i].get_node("TextureRect").visible = true
			
		children[i].add_theme_stylebox_override("normal", normal)
		children[i].add_theme_stylebox_override("hover", normal)
		children[i].add_theme_stylebox_override("focus", normal)
		children[i].add_theme_stylebox_override("pressed", pressed)
		
func _on_start_button_pressed(index) -> void:
	Globals.current_level = index
	SceneChanger.change_scene_to("res://scenes/levels/level"+str(Globals.current_level)+".tscn")
	
func _on_options_button_pressed() -> void:
	pass # Replace with function body.
	
func _on_credits_button_pressed() -> void:
	$Credits.visible = true

func _on_close_credits_pressed() -> void:
	$Credits.visible = false
