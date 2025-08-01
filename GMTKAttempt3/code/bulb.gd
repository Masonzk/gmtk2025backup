extends StaticBody3D

@export var color : Globals.colors_enum

var left_connected = false
var right_connected = false

var lit = false

func _ready() -> void:
	#$MeshInstance3D.get_surface_override_material(0).albedo_color = Globals.colors_array[color][0]
	$RightTerminal.get_surface_override_material(0).albedo_color = Globals.colors_array[color][0]
	$LeftTerminal.get_surface_override_material(0).albedo_color = Globals.colors_array[color][1]

@onready var rays = [$Right, $Left]
var connected = [false, false]

func _process(delta: float) -> void:
	connected = [false, false]
	for i in range(rays.size()):
		if rays[i].is_colliding():
			if rays[i].get_collider().is_in_group("selection"):
				if rays[i].get_collider().color_id == color and rays[i].get_collider().shade == i:
					if !rays[i].get_collider().disabled:
						$Connect.play()
					rays[i].get_collider().disable()
					connected[i] = true
					
	if connected[0] and connected[1] and !lit:
		lit = true
		$Lit.play()
		$BulbMesh.get_surface_override_material(0).albedo_color = Globals.colors_array[color][0]
		$BulbMesh/MeshInstance3D.visible = true
		
		Globals.unlit_bulbs -= 1
		
	if !(connected[0] and connected[1]) and lit:
		lit = false
		$Disconnect.play()
		$BulbMesh.get_surface_override_material(0).albedo_color = "#34343432"#Globals.colors_array[color][0]
		$BulbMesh/MeshInstance3D.visible = false
		
		Globals.unlit_bulbs += 1
