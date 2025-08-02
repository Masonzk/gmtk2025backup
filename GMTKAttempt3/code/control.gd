extends Control

func _ready() -> void:
	if Globals.current_level == -1:
		$LevelLabel.text = "TUTORIAL"
	else:
		$LevelLabel.text = "LEVEL " + str(Globals.current_level+1)
	$Panel.visible = false #Globals.levels[Globals.current_level]
	
func _on_menu_button_pressed() -> void:
	SceneChanger.change_scene_to("res://scenes/menu.tscn")
	
func _on_next_level_button_pressed() -> void:
	Globals.current_level += 1
	SceneChanger.change_scene_to("res://scenes/levels/level"+str(Globals.current_level)+".tscn")


func _on_previous_level_button_pressed() -> void:
	Globals.current_level -= 1
	SceneChanger.change_scene_to("res://scenes/levels/level"+str(Globals.current_level)+".tscn")
