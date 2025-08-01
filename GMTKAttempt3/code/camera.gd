extends Node3D

var mouse_sensitivity = 0.15
var zoom = 12

var wires = [[[], []], [[], []], [[], []], [[], []], [[], []]]

var cursor_open = preload("res://pointer_a.png")
var cursor_closed = preload("res://hand_closed.png")

func _ready() -> void:
	#for i in range(Globals.colors_enum.size()-1):
		#wires.append([])
		
	Globals.unlit_bulbs = get_tree().get_nodes_in_group("bulb").size()
		
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("right_mouse"):
		#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		#Input.set_custom_mouse_cursor(cursor_closed)
		pass
	if Input.is_action_just_released("right_mouse"):
		#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		#Input.set_custom_mouse_cursor(cursor_open)
		pass
		
	if event is InputEventMouseMotion and Input.is_action_pressed("right_mouse"):
		rotate_object_local(Vector3(1, 0, 0), deg_to_rad(-event.relative.y * mouse_sensitivity))
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))

@onready var ray = $Camera3D/RayCast3D
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("undo"):
		print("UNDO")
		
	if Input.is_action_just_pressed("mouse_wheel_up"):
		zoom -= 0.5
	elif Input.is_action_just_pressed("mouse_wheel_down"):
		zoom += 0.5
	
	$Camera3D.size = lerpf($Camera3D.size, zoom, 0.1)
	
	zoom = clamp(zoom, 4, 24)
	
	if get_parent().victory: return
		
	if Input.is_action_just_pressed("left_mouse"):
		var pos = get_viewport().get_mouse_position()
		var ray_origin = $Camera3D.project_ray_origin(pos)
		var ray_end = ray_origin + $Camera3D.project_ray_normal(pos) * 1000
		var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end, 2)
		var intersect = get_world_3d().direct_space_state.intersect_ray(query)
		if intersect != {}:
			#print(intersect)
			if intersect["collider"].is_in_group("selection"):
				spawn_wire(intersect["collider"], intersect["normal"])
			elif intersect["collider"].is_in_group("rewind"):
				rewind(intersect["collider"].get_parent().color)

func rewind(color : int):
	while wires[color][0].size() > 0 or wires[color][1].size() > 0:
		if wires[color][0].size() > 0:
			Globals.coils[color][0].disable()
			var new_coil = wires[color][0].pop_back()
			Globals.coils[color][0].global_transform.origin = new_coil.global_transform.origin
			new_coil.queue_free()
		if wires[color][1].size() > 0:
			Globals.coils[color][1].disable()
			var new_coil = wires[color][1].pop_back()
			Globals.coils[color][1].global_transform.origin = new_coil.global_transform.origin
			new_coil.queue_free()
		await get_tree().create_timer(0.02).timeout
		
	Globals.coils[color][0].enable()
	Globals.coils[color][1].enable()

var prev_selected_collider : Object

func spawn_wire(collider, normal):
	if collider.disabled: return
	if !collider.selected:
		collider.selected = true
		if prev_selected_collider != null and collider != prev_selected_collider:
			prev_selected_collider.selected = false
		prev_selected_collider = collider
		return
		
	var next_pos = collider.global_transform.origin + normal
	var bounds = get_parent().get_node("Bounds").mesh.size
	if abs(next_pos.x) > bounds.x*0.5 or abs(next_pos.y) > bounds.y*0.5 or abs(next_pos.z) > bounds.z*0.5:
		collider.error()
		$Error.play()
		return
		
	var query = PhysicsRayQueryParameters3D.create(collider.global_transform.origin, collider.global_transform.origin+normal)
	var intersect = get_world_3d().direct_space_state.intersect_ray(query)
	if intersect != {}:
		if intersect["collider"].is_in_group("obstruction"):
			collider.error()
			$Error.play()
			return
				
	var prev_normal = collider.history.back()
	collider.history.append(normal)
	var instance = load("res://scenes/wire.tscn").instantiate()
	instance.transform.origin = collider.global_transform.origin
	print(prev_normal)
	print(normal)
	if prev_normal.is_equal_approx(normal):
		instance.get_node("Straight").visible = true
		instance.get_node("Straight").get_surface_override_material(0).albedo_color = collider.get_node("MeshInstance3D").get_surface_override_material(0).albedo_color
		instance.look_at_from_position(instance.transform.origin, instance.transform.origin+normal)
	else:
		instance.get_node("Corner").visible = true
		instance.get_node("Corner").get_surface_override_material(0).albedo_color = collider.get_node("MeshInstance3D").get_surface_override_material(0).albedo_color
		#instance.look_at_from_position(instance.transform.origin, instance.transform.origin+normal)
		
		var cross = -prev_normal + normal
		#print(cross)
		if cross.y == 0:
			instance.get_node("Corner").rotation_degrees = Vector3(0, 135, 0)
		else:
			instance.get_node("Corner").rotation_degrees = Vector3(-45, 180, -90)
			
		instance.look_at_from_position(instance.transform.origin, instance.transform.origin+cross)
		#instance.get_node("Arrow").look_at(instance.global_transform.origin+cross)
		#var stored_transform = instance.transform
		#stored_transform.basis.z = cross
		#stored_transform.basis.x = stored_transform.basis.y.cross(cross)
		#stored_transform.basis = stored_transform.basis.orthonormalized()
		#instance.transform = stored_transform
	
	wires[collider.color_id][collider.shade].append(instance)
	get_parent().add_child(instance)
	
	randomize()
	$Place.pitch_scale = randf_range(0.8, 1)
	$Place.play()
	collider.global_transform.origin = next_pos
#func _input(event):
	#if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		#rotate_object_local(Vector3(0,1,0), deg_to_rad(-event.relative.x * mouse_sensitivity))
		#camera.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		#camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
