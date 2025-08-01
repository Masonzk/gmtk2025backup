extends Node3D

var build_up = true

@export var shade : int

func _ready() -> void:
	randomize()
	$Blocks/MeshInstance3D.get_surface_override_material(0).albedo_color = Globals.colors_array[randi_range(0, 4)][shade]
func _process(delta: float) -> void:
	pass
	#if build_up:
		#for block in $Blocks.get_children():
			#block.visible = true
			#await get_tree().create_timer(0.25).timeout
		#build_up = false
	#else:
		#var blocks = $Blocks.get_children()
		#blocks.reverse()
		##for i in range(children.size()):
		#for block in blocks:
			#block.visible = false
			#await get_tree().create_timer(0.05).timeout
		#build_up = true
			#
