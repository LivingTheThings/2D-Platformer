extends AudioStreamPlayer

const MUSIC := preload("res://Audio/bgMusic.mp3")


func _ready() -> void:
	stream = MUSIC
	if stream is AudioStreamMP3:
		stream.loop = true
	volume_db = -16.0
	play()
