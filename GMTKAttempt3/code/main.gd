extends Node3D

var victory = false

@export var song : int

func _ready() -> void:
	MusicManager.queue_song(song)
	if Globals.current_level == 7:
		$Control/NextLevelButton.disabled = true
	if Globals.current_level == 0:
		$Control/PreviousLevelButton.disabled = true
	if Globals.current_level == 99:
		$Control/NextLevelButton.disabled = true
		$Control/PreviousLevelButton.disabled = true
		
	Globals.unlit_bulbs = get_tree().get_nodes_in_group("bulb").size()
	
	$Control/LevelInfo.text = str(int($Bounds.mesh.size.x)) + "x" + str(int($Bounds.mesh.size.y)) + "x" + str(int($Bounds.mesh.size.z)) + " • " + str(Globals.unlit_bulbs) + " bulbs"

var bulb_colors = []
var index = 0

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_win"):
		Globals.unlit_bulbs = 0
		
	if Globals.unlit_bulbs <= 0 and !victory:
		victory = true
		
		#for bulb in get_tree().get_nodes_in_group("bulb"):
			#bulb_colors.append(Globals.colors_array[bulb.color][0])
		for color in range(4):
			bulb_colors.append(Globals.colors_array[color][0])
		
		_on_timer_timeout()
		$Bounds/Timer.start()
			
		if Globals.current_level == -1:
			Globals.completed_tutorial = true
		else:
			Globals.levels[Globals.current_level] = true
		$Victory.play()
		$CPUParticles3D.emission_box_extents = Vector3($Bounds.mesh.size.x*0.5, 1, $Bounds.mesh.size.z*0.5)
		$CPUParticles3D.transform.origin.y = $Bounds.mesh.size.y*0.5
		$CPUParticles3D.emitting = true
		
		$Control/Panel.visible = true

func _on_timer_timeout() -> void:
	$Bounds.get_surface_override_material(0).albedo_color = bulb_colors[index]
	$Bounds.get_surface_override_material(0).albedo_color.a = .50
	print("switch color")
	index += 1
	if index >= bulb_colors.size():
		index = 0
