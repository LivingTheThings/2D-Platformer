extends Node2D

@onready var interactable_label: Label = $InteractLabel
@onready var interact_range: Area2D = $InteractRange
@onready var interact_shape: CollisionShape2D = $InteractRange/CollisionShape2D
@export var scene_to_load : PackedScene
@export_file("*.tscn") var scene_path: String = ""

var player_in_range: bool = false
var can_interact: bool = true


func _ready() -> void:
	interact_range.monitoring = true
	interactable_label.hide()


func _physics_process(_delta: float) -> void:
	update_player_in_range()
	if Input.is_action_just_pressed("interact"):
		try_interact()


func update_player_in_range() -> void:
	player_in_range = has_player_in_range()

	if player_in_range:
		interactable_label.show()
	else:
		interactable_label.hide()


func has_player_in_range() -> bool:
	for body in interact_range.get_overlapping_bodies():
		if body.is_in_group("Players"):
			return true

	var interact_radius := get_interact_radius()
	for node in get_tree().get_nodes_in_group("Players"):
		if node is Node2D and node.global_position.distance_to(global_position) <= interact_radius:
			return true

	return false


func get_interact_radius() -> float:
	if interact_shape.shape is CircleShape2D:
		return interact_shape.shape.radius

	return 19.0


func try_interact() -> void:
	update_player_in_range()

	if not player_in_range:
		return

	if not can_interact:
		return

	can_interact = false
	interact()


func interact() -> void:
	if scene_to_load != null:
		var packed_error := get_tree().change_scene_to_packed(scene_to_load)
		if packed_error != OK:
			can_interact = true
		return

	if scene_path != "":
		var file_error := get_tree().change_scene_to_file(scene_path)
		if file_error != OK:
			can_interact = true
		return

	can_interact = true

func _on_interact_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players"):
		player_in_range = true
		interactable_label.show()

func _on_interact_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("Players"):
		player_in_range = false
		interactable_label.hide()
