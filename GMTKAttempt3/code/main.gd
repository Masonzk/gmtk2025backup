extends Node3D

var victory = false

func _ready() -> void:
	if Globals.current_level == 9:
		$Control/NextLevelButton.disabled = true
	if Globals.current_level == 0:
		$Control/PreviousLevelButton.disabled = true
	Globals.unlit_bulbs = get_tree().get_nodes_in_group("bulb").size()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_win"):
		Globals.unlit_bulbs = 0
		
	if Globals.unlit_bulbs <= 0 and !victory:
		victory = true
		Globals.levels[Globals.current_level] = true
		$Victory.play()
		$CPUParticles3D.emission_box_extents = Vector3($Bounds.mesh.size.x*0.5, 1, $Bounds.mesh.size.z*0.5)
		$CPUParticles3D.transform.origin.y = $Bounds.mesh.size.y*0.5
		$CPUParticles3D.emitting = true
