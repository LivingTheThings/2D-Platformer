extends Node2D

@onready var interactable_label: Label = $InteractLabel
@onready var interact_range: Area2D = $InteractRange
@export var scene_to_load : PackedScene
var player_in_range: bool = false
var can_interact: bool = true


func _ready() -> void:
	interact_range.monitoring = true
	interactable_label.hide()


func _physics_process(_delta: float) -> void:
	update_player_in_range()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		try_interact()


func update_player_in_range() -> void:
	player_in_range = false

	for body in interact_range.get_overlapping_bodies():
		if body.is_in_group("Players"):
			player_in_range = true
			break

	if player_in_range:
		interactable_label.show()
	else:
		interactable_label.hide()


func try_interact() -> void:
	update_player_in_range()

	if not player_in_range:
		return

	if not can_interact:
		return

	can_interact = false
	interact()


func interact() -> void:
	if scene_to_load == null:
		can_interact = true
		return

	var error := get_tree().change_scene_to_packed(scene_to_load)
	if error != OK:
		can_interact = true

func _on_interact_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players"):
		player_in_range = true
		interactable_label.show()

func _on_interact_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("Players"):
		player_in_range = false
		interactable_label.hide()
