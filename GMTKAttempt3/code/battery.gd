extends Node3D

@export var color : Globals.colors_enum

func _ready() -> void:
	$Rewind/RewindButtonMesh.get_surface_override_material(0).albedo_color = Globals.colors_array[color][0]
	$Terminal1.get_surface_override_material(0).albedo_color = Globals.colors_array[color][0]
	$Terminal2.get_surface_override_material(0).albedo_color = Globals.colors_array[color][1]
	
	for i in range(2):
		var instance = load("res://scenes/coil.tscn").instantiate()
		instance.transform.origin = get_node("Position"+str(i+1)).global_transform.origin
		var prev_normal = get_node("Position"+str(i+1)).global_transform.origin-get_node("Normal"+str(i+1)).global_transform.origin
		instance.history.append(round(prev_normal))
		instance.get_node("MeshInstance3D").get_surface_override_material(0).albedo_color = Globals.colors_array[color][i]
		instance.color = Globals.colors_array[color][i]
		instance.color_id = color
		instance.shade = i
		get_parent().add_child.call_deferred(instance)
		Globals.coils[color].append(instance)

func _process(delta: float) -> void:
	$Rewind/Sprite3D.rotation_degrees.z -= 200*delta
