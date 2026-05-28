extends Area2D

@export var scene_to_load : PackedScene
@export_file("*.tscn") var scene_path: String = ""
@export var requires_key: bool = false



func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Players"):
		return

	if requires_key and not PlayerStats.has_key:
		return

	if scene_to_load != null:
		get_tree().change_scene_to_packed(scene_to_load)
	elif scene_path != "":
		get_tree().change_scene_to_file(scene_path)
