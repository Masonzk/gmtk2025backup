extends StaticBody3D

var history = []

var selected = false

var disabled = false

var color
var color_id : int
var shade : int

func _process(delta: float) -> void:
	#$Arrows.visible = selected
	$MeshInstance3D/Outline.visible = selected

func disable():
	disabled = true
	selected = false
	set_collision_mask_value(2, false)
	set_collision_layer_value(2, false)
	#$CollisionShape3D.disabled = true

func enable():
	disabled = false
	set_collision_mask_value(2, true)
	set_collision_layer_value(2, true)
	
func error():
	$MeshInstance3D/AnimationPlayer.play("ERROR")
