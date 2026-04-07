extends Area2D
func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Players"):
		return

	body.take_damage(1)
