extends Node3D

var target_positions = [Vector3.ZERO, Vector3.ZERO, Vector3.ZERO, Vector3.ZERO]

@onready var coils = [$Coil1, $Coil2, $Coil3, $Coil4]
@onready var blocks = [$Blocks, $Blocks2, $Blocks3, $Blocks4]
var complete_array = []

func _ready() -> void:
	for i in range(coils.size()):
		coils[i].global_transform.origin = blocks[i].get_children()[0].global_transform.origin
		target_positions[i] = blocks[i].get_children()[0].global_transform.origin
	await get_tree().create_timer(1).timeout
	build_up()
	
func _process(delta: float) -> void:
	for i in range(coils.size()):
		coils[i].global_transform.origin = lerp(coils[i].global_transform.origin, target_positions[i], 1)

func light():
	$Bulb.connected[0] = true
	$Bulb.connected[1] = true
	$Bulb2.connected[0] = true
	$Bulb2.connected[1] = true
	
func unlight():
	$Bulb.connected[0] = false
	$Bulb.connected[1] = false
	$Bulb2.connected[0] = false
	$Bulb2.connected[1] = false
	
func build_up():
	complete_array = [false, false, false, false]
	while !(complete_array[0] and complete_array[1] and complete_array[2] and complete_array[3]):
		for i in range(blocks.size()):
			var complete = true
			var children = blocks[i].get_children()
			for j in range(children.size()-1):
				if !children[j].visible:
					children[j].visible = true
					target_positions[i] = children[j+1].global_transform.origin
					complete = false
					break
			if complete: complete_array[i] = true
		await get_tree().create_timer(0.1).timeout
	light()
	await get_tree().create_timer(1).timeout
	build_down()
				
func build_down():
	unlight()
	complete_array = [false, false, false, false]
	while !(complete_array[0] and complete_array[1] and complete_array[2] and complete_array[3]):
		for i in range(blocks.size()):
			var complete = true
			var children = blocks[i].get_children()
			for j in range(children.size()-1, 0, -1):
				if children[j].visible:
					children[j].visible = false
					target_positions[i] = children[j-1].global_transform.origin
					complete = false
					break
			if complete: complete_array[i] = true
		await get_tree().create_timer(0.05).timeout
	#build_up()
