extends StaticBody3D

@export var color : Globals.colors_enum

var right_connected = true

var lit = false

func _ready() -> void:
	#$MeshInstance3D.get_surface_override_material(0).albedo_color = Globals.colors_array[color][0]
	$RightTerminal.get_surface_override_material(0).albedo_color = Globals.colors_array[color][0]
	$RightGripper.get_surface_override_material(0).albedo_color = Globals.colors_array[color][0]
	$LeftTerminal.get_surface_override_material(0).albedo_color = Globals.colors_array[color][1]
	$LeftGripper.get_surface_override_material(0).albedo_color = Globals.colors_array[color][1]
	
	$BulbMesh.get_surface_override_material(0).albedo_color = "#34343432" #"#34343432"
	$BulbMesh/Filament.get_surface_override_material(0).albedo_color = "#525252"
	$BulbMesh/MeshInstance3D.visible = false
	$BulbMesh/Glow.visible = false
	#$BulbMesh/MeshInstance3D.get_surface_override_material(0).albedo_color = "#5f5f5f"

@onready var rays = [$Right, $Left]
var connected = [false, false]

#var time = 0.0
#var direction = 1

func _process(delta: float) -> void:
	#if time >= 1.0:
		#direction = -1
	#if time <= 0.0:
		#direction = 1
	#time += delta*direction
	#time = clamp(time, 0, 1)
	#$BulbMesh/Glow.set_instance_shader_parameter("time", time)
	
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
		$BulbMesh.get_surface_override_material(0).albedo_color = Globals.colors_array[color][0] + "f0"
		$BulbMesh.get_surface_override_material(0).shading_mode = 0
		#$BulbMesh.get_surface_override_material(0).emission_enabled = true
		#$BulbMesh.get_surface_override_material(0).energy_multiplier = 5
		#$BulbMesh.get_surface_override_material(0).emission = Globals.colors_array[color][0]
		#$BulbMesh/MeshInstance3D.get_surface_override_material(0).albedo_color = "#FFFFFF"
		$BulbMesh/MeshInstance3D.visible = true
		$BulbMesh/Filament.get_surface_override_material(0).albedo_color = "#FFFFFF"
		$BulbMesh/Glow.visible = true
		
		Globals.unlit_bulbs -= 1
		
	if !(connected[0] and connected[1]) and lit:
		lit = false
		$Disconnect.play()
		$BulbMesh.get_surface_override_material(0).albedo_color = "#34343432"#Globals.colors_array[color][0]
		$BulbMesh/Filament.get_surface_override_material(0).albedo_color = "#525252"
		$BulbMesh/MeshInstance3D.visible = false
		
		$BulbMesh/Glow.visible = false
		
		Globals.unlit_bulbs += 1
