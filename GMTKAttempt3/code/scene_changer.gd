extends CanvasLayer

func change_scene_to(path):
	$AnimationPlayer.play("slide_in")
	await $AnimationPlayer.animation_finished
	reset_globals()
	get_tree().change_scene_to_file(path)
	$AnimationPlayer.play_backwards("slide_in")

func reset_globals():
	Globals.coils = [[], [], [], [], []]
