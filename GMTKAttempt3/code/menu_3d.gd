extends Node3D

@export var shade : int

var color : int

var target_pos : Vector3

signal connected
signal disconnected

#func _ready() -> void:
	#$Coil.get_surface_override_material(0).albedo_color = Globals.colors_array[color][shade]

func _process(delta: float) -> void:
	$Coil.transform.origin = lerp($Coil.transform.origin, target_pos, 0.3)
	
func build_up():
	$Coil.get_surface_override_material(0).albedo_color = Globals.colors_array[color][shade]
	
	var blocks = $Blocks.get_children()
	for block in range(blocks.size()-1):
		#$Coil.transform.origin = blocks[block+1].transform.origin
		target_pos = blocks[block+1].global_transform.origin
		blocks[block].visible = true
		await get_tree().create_timer(0.15).timeout #0.5
	emit_signal("connected")
	await get_tree().create_timer(5).timeout
	build_down()

func build_down():
	emit_signal("disconnected")
	var blocks = $Blocks.get_children()
	for block in range(blocks.size()-1):
		var i = blocks.size()-block-1
		#$Coil.transform.origin = blocks[block+1].transform.origin
		target_pos = blocks[i-1].global_transform.origin
		blocks[i].visible = false
		await get_tree().create_timer(0.1).timeout #0.25
	await get_tree().create_timer(1).timeout
	build_up()
