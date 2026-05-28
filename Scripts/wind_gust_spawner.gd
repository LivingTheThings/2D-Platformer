extends Node2D

@export var wind_gust_scene: PackedScene
@export var spawn_interval_min: float = 0.8
@export var spawn_interval_max: float = 1.8
@export var area_min: Vector2 = Vector2(-80, -120)
@export var area_max: Vector2 = Vector2(1500, 140)
@export var min_scale: float = 0.35
@export var max_scale: float = 0.55
@export var spawn_near_player: bool = true
@export var spawn_offset_min: Vector2 = Vector2(-220, -95)
@export var spawn_offset_max: Vector2 = Vector2(120, 55)

@onready var player: Node2D = get_parent().get_node_or_null("Player")

func _ready() -> void:
	randomize()
	for i in range(3):
		spawn_gust()
	_spawn_loop()

func _spawn_loop() -> void:
	while is_inside_tree():
		spawn_gust()
		await get_tree().create_timer(randf_range(spawn_interval_min, spawn_interval_max)).timeout

func spawn_gust() -> void:
	if wind_gust_scene == null:
		return
	
	var gust = wind_gust_scene.instantiate()
	add_child(gust)
	
	if spawn_near_player and player != null:
		gust.global_position = player.global_position + Vector2(
			randf_range(spawn_offset_min.x, spawn_offset_max.x),
			randf_range(spawn_offset_min.y, spawn_offset_max.y)
		)
	else:
		gust.position = Vector2(
			randf_range(area_min.x, area_max.x),
			randf_range(area_min.y, area_max.y)
		)
	
	var gust_scale = randf_range(min_scale, max_scale)
	gust.scale = Vector2(gust_scale, gust_scale)
	gust.trail_speed = randf_range(0.007, 0.012)
	gust.trail_length = randf_range(0.45, 0.65)
	gust.random_y_offset = randf_range(6.0, 20.0)
