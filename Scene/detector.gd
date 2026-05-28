extends Area2D

@export var attack_speed: float = 180.0
@export var return_speed: float = 80.0

var player: Node2D = null
var bird: Node2D = null
var sprite: Sprite2D = null
var anim: AnimationPlayer = null
var start_pos: Vector2
var target_pos: Vector2
var attacking: bool = false
var going_back: bool = false
var can_hit: bool = false


func _ready() -> void:
	bird = get_parent()
	sprite = bird.get_node("Sprite2D")
	anim = bird.get_node("AnimationPlayer")
	start_pos = bird.global_position
	target_pos = start_pos
	
	if body_entered.is_connected(_on_body_entered) == false:
		body_entered.connect(_on_body_entered)
	if body_exited.is_connected(_on_body_exited) == false:
		body_exited.connect(_on_body_exited)
	if bird.body_entered.is_connected(_on_bird_body_entered) == false:
		bird.body_entered.connect(_on_bird_body_entered)


func _physics_process(delta: float) -> void:
	if attacking:
		face_position(target_pos)
		bird.global_position = bird.global_position.move_toward(target_pos, attack_speed * delta)
		
		if bird.global_position.distance_to(target_pos) < 2:
			attacking = false
			going_back = true
			can_hit = false
			anim.play("idle")
	
	elif going_back:
		face_position(start_pos)
		bird.global_position = bird.global_position.move_toward(start_pos, return_speed * delta)
		
		if bird.global_position.distance_to(start_pos) < 2:
			going_back = false
			bird.global_position = start_pos
			anim.play("idle")


func start_attack() -> void:
	if player == null:
		return
	
	target_pos = player.global_position
	face_position(target_pos)
	attacking = true
	can_hit = true
	anim.play("attack")


func face_position(pos: Vector2) -> void:
	if pos.x < bird.global_position.x:
		sprite.flip_h = true
	else:
		sprite.flip_h = false


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players") == false:
		return
	
	if attacking or going_back:
		return
	
	player = body
	start_attack()


func _on_body_exited(body: Node2D) -> void:
	if body == player:
		player = null


func _on_bird_body_entered(body: Node2D) -> void:
	if can_hit == false:
		return
	
	if body.is_in_group("Players"):
		body.take_damage(1)
		can_hit = false
