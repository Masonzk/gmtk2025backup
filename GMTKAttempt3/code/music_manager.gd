extends Node

@onready var songs = [
	preload("res://music/Sketchbook 2024-11-13.ogg"),
	preload("res://music/Sketchbook 2024-11-20.ogg"), #USED
	preload("res://music/Sketchbook 2024-12-04.ogg"),
	preload("res://music/Sketchbook 2024-11-07.ogg"), #USED
	preload("res://music/Sketchbook 2024-10-23.ogg"), #USED
	preload("res://music/Sketchbook 2024-09-25.ogg"), #USED
	preload("res://music/Sketchbook 2024-11-29.ogg")
	]
	
var next_song = 0

func queue_song(song):
	if song == next_song: return
	next_song = song
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.play("switch_songs")
	else:
		$AnimationPlayer.play_section("switch_songs", 1.25)

func switch_songs():
	$AudioStreamPlayer.stream = songs[next_song]
	$AudioStreamPlayer.play()
