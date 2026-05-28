#https://github.com/shashank1q/Godot-leaf_falling/

extends Node2D

@export var leaf_texture: Texture2D
@export var amount: int = 24
@export var spawn_padding: float = 80.0
@export var fall_speed_min: float = 24.0
@export var fall_speed_max: float = 52.0
@export var wind_speed_min: float = -10.0
@export var wind_speed_max: float = 18.0
@export var rotation_speed_min: float = -1.8
@export var rotation_speed_max: float = 1.8
@export var scale_min: float = 0.01
@export var scale_max: float = 0.02
@export var sway_strength: float = 16.0

var leaves: Array = []

func _ready() -> void:
	randomize()
	for i in range(amount):
		var leaf := Sprite2D.new()
		leaf.texture = leaf_texture
		leaf.centered = true
		leaf.z_index = 45
		add_child(leaf)
		leaves.append({
			"node": leaf,
			"fall_speed": randf_range(fall_speed_min, fall_speed_max),
			"wind_speed": randf_range(wind_speed_min, wind_speed_max),
			"rotation_speed": randf_range(rotation_speed_min, rotation_speed_max),
			"sway_speed": randf_range(1.4, 2.8),
			"sway_offset": randf_range(0.0, TAU)
		})
		_reset_leaf(leaves[i], true)

func _process(delta: float) -> void:
	var visible_rect = _get_visible_world_rect()
	var time = Time.get_ticks_msec() / 1000.0
	
	for leaf_data in leaves:
		var leaf: Sprite2D = leaf_data["node"]
		var position = leaf.global_position
		position.x += leaf_data["wind_speed"] * delta
		position.x += sin(time * leaf_data["sway_speed"] + leaf_data["sway_offset"]) * sway_strength * delta
		position.y += leaf_data["fall_speed"] * delta
		leaf.global_position = position
		leaf.rotation += leaf_data["rotation_speed"] * delta
		
		if position.y > visible_rect.position.y + visible_rect.size.y + spawn_padding:
			_reset_leaf(leaf_data, false)

func _reset_leaf(leaf_data: Dictionary, start_visible: bool) -> void:
	var visible_rect = _get_visible_world_rect()
	var leaf: Sprite2D = leaf_data["node"]
	var x = randf_range(
		visible_rect.position.x - spawn_padding,
		visible_rect.position.x + visible_rect.size.x + spawn_padding
	)
	var y: float
	
	if start_visible:
		y = randf_range(visible_rect.position.y - spawn_padding, visible_rect.position.y + visible_rect.size.y)
	else:
		y = randf_range(visible_rect.position.y - spawn_padding, visible_rect.position.y - 10.0)
	
	leaf.global_position = Vector2(x, y)
	var leaf_scale = randf_range(scale_min, scale_max)
	leaf.scale = Vector2(leaf_scale, leaf_scale)
	leaf.rotation = randf_range(0.0, TAU)
	leaf.modulate = Color(randf_range(0.8, 1.0), randf_range(0.65, 0.9), randf_range(0.25, 0.45), randf_range(0.55, 0.85))

func _get_visible_world_rect() -> Rect2:
	var canvas = get_canvas_transform()
	var top_left = -canvas.origin / canvas.get_scale()
	var size = get_viewport_rect().size / canvas.get_scale()
	return Rect2(top_left, size)
