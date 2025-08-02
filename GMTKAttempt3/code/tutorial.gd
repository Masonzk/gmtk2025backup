extends Control

var prompts = [
	"CLICK TO SELECT A COIL",
	"CLICK FACES TO EXTRUDE WIRE",
	"CONNECT ALL MATCHING COLORS",
	"RIGHT CLICK & DRAG\nTO ADJUST VIEW"
]
var images = [
	preload("res://tutorial1.png"),
	preload("res://tutorial2.png"),
	preload("res://tutorial3.png"),
	preload("res://tutorial4.png"),
	]

var index = 0

func _on_next_prompt_button_pressed() -> void:
	index += 1
	if index >= prompts.size():
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		visible = false
		return
	$Panel/TextureRect.texture = images[index]
	$Panel/Label.text = prompts[index]
