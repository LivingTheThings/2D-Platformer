extends Area2D

@export var scene_to_load : PackedScene
@export_file("*.tscn") var scene_path: String = ""

var collected: bool = false


func _ready() -> void:
	monitoring = true


func _physics_process(_delta: float) -> void:
	if collected:
		return

	for body in get_overlapping_bodies():
		if body.is_in_group("Players"):
			collect_key()
			return


func _on_body_entered(body: Node2D) -> void:
	if collected or not body.is_in_group("Players"):
		return

	collect_key()


func collect_key() -> void:
	if collected:
		return

	collected = true
	PlayerStats.has_key = true

	if scene_to_load != null:
		get_tree().change_scene_to_packed(scene_to_load)
	elif scene_path != "":
		get_tree().change_scene_to_file(scene_path)
