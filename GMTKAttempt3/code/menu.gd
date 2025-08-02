extends Control

var color : int

func _ready() -> void:
	MusicManager.queue_song(3)
	
	$Credits.visible = false
	$Options.visible = false
	
	if Globals.completed_tutorial: $Panel.visible = false
	else: $Panel.visible = true
	
	randomize()
	color = randi_range(0, 4)
	
	$SubViewportContainer/SubViewport/Menu3D.color = color
	$SubViewportContainer2/SubViewport/Menu3D.color = color
	
	$SubViewportContainer/SubViewport/Menu3D.build_up()
	$SubViewportContainer2/SubViewport/Menu3D.build_up()
	
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
			
			normal.border_color = Globals.colors_array[color][0]
			
			children[i].get_node("TextureRect").visible = true
		
		children[i].add_theme_stylebox_override("normal", normal)
		children[i].add_theme_stylebox_override("hover", normal)
		children[i].add_theme_stylebox_override("focus", normal)
		children[i].add_theme_stylebox_override("pressed", pressed)
		
func _on_start_button_pressed(index) -> void:
	Globals.current_level = index
	SceneChanger.change_scene_to("res://scenes/levels/level"+str(Globals.current_level)+".tscn")
	
func _on_options_button_pressed() -> void:
	$Options.visible = true
	$Options.mouse_filter = MOUSE_FILTER_STOP
	
func _on_credits_button_pressed() -> void:
	$Credits.visible = true
	$Credits.mouse_filter = MOUSE_FILTER_STOP

func _on_close_credits_pressed() -> void:
	$Credits.visible = false
	$Credits.mouse_filter = MOUSE_FILTER_IGNORE
	
func _on_close_options_pressed() -> void:
	$Options.visible = false
	$Options.mouse_filter = MOUSE_FILTER_IGNORE
	
func _on_volume_slider_value_changed(value: float) -> void:
	Globals.change_volume("Master", value, value <= $Options/VolumeSlider.min_value)


func _on_tutorial_button_pressed() -> void:
	Globals.current_level = -1
	SceneChanger.change_scene_to("res://scenes/tutorial.tscn")

func _on_skip_tutorial_pressed() -> void:
	Globals.completed_tutorial = true
	$Panel.visible = false
	
func _on_music_volume_slider_value_changed(value: float) -> void:
	Globals.change_volume("Music", value, value <= $Options/VolumeSlider.min_value)

func _on_menu_3d_connected() -> void:
	#$Connect.play()
	$Label.add_theme_constant_override("outline_size", 5)
	$Label.add_theme_font_size_override("font_size", 64)
	$Label.add_theme_color_override("font_color", Globals.colors_array[color][0])
	$Glow.visible = true
	#$Label.add_theme_color_override("font_outline_color", Globals.colors_array[color][1])

func _on_menu_3d_disconnected() -> void:
	#$Disconnect.play()
	$Label.add_theme_constant_override("outline_size", 5)
	$Label.add_theme_font_size_override("font_size", 60)
	$Label.add_theme_color_override("font_color", "#191919")
	$Glow.visible = false
	
func _on_secret_level_pressed() -> void:
	Globals.current_level = 99
	SceneChanger.change_scene_to("res://scenes/secret_level.tscn")
