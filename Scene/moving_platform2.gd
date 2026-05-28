extends AnimatableBody2D

@export var move_time: float = 2.0
@export var cooldown: float = 1.0

@onready var start_marker: Marker2D = $"../Ends2"
@onready var end_marker: Marker2D = $"../Start2"

var going_to_end: bool = true


func _ready() -> void:
	global_position = start_marker.global_position
	move_platform()


func move_platform() -> void:
	var next_pos: Vector2
	
	if going_to_end:
		next_pos = end_marker.global_position
	else:
		next_pos = start_marker.global_position
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", next_pos, move_time)
	await tween.finished
	
	await get_tree().create_timer(cooldown).timeout
	
	going_to_end = not going_to_end
	move_platform()
