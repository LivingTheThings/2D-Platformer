extends CharacterBody2D

signal OnUpdateHealth (health : int)
signal OnUpdateScore(score : int)
#configuration
@export var move_speed : float = 100 
@export var acceleration : float = 50 
@export var braking : float = 20
@export var gravity : float = 500
@export var jump_force : float = 200
@export var climb_speed : float
@export var target_spike_cd: float = 0.0
var move_input : float 
var debloat: bool = false
var has_double_jump :bool = false
var during_double :bool = false

@onready var sprite : Sprite2D = $Sprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var tile_map: TileMapLayer = $"../TileMapLayer"
@onready var was_touching_gem :bool = tile_map.touched_gem(global_position)
@export var health : int = 3


var is_climb = false
var take_damage_sfx : AudioStream = preload("res://Audio/take_damage.wav")
var coin_sfx : AudioStream = preload("res://Audio/coin.wav")



func _physics_process(delta: float) -> void:
	var climb_input = Input.get_axis("jump", "climb_down")
	var bool_damage = tile_map.touched_spike(global_position)
	var bool_climb = tile_map._on_ladder_on_player(global_position)
	var gem_activated = tile_map.touched_gem(global_position)
	var is_damage = true
	move_input = Input.get_axis("move_left", "move_right")

	if gem_activated and not was_touching_gem:
		has_double_jump = true
		during_double = false
	was_touching_gem = gem_activated

	if bool_climb and climb_input != 0:
		is_climb = true
	if bool_climb == false:
		is_climb = false

	if is_climb:
		velocity.y = climb_input * climb_speed
	else:
		velocity.x = move_input * move_speed
		if not is_on_floor():
			velocity.y += gravity * delta
		else:
			during_double = false

	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = -jump_force
		elif has_double_jump and not during_double:
			velocity.y = -jump_force
			during_double = true
			has_double_jump = false
	
	move_and_slide()	
	
	if move_input != 0:
		velocity.x = lerp(velocity.x, move_input * move_speed, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, braking * delta)

	if bool_damage and not debloat:
		debloat = true
		
		take_damage(1)
		velocity.y = -jump_force
		await get_tree().create_timer(0.8).timeout
		
		debloat = false
	
	
		


func _process(_delta: float) -> void:
	if velocity.x != 0:
		sprite.flip_h = velocity.x < 0 
		
	if global_position.y > 200:
		game_over()
	_manage_animation()

func _manage_animation():
	if not is_on_floor():
		anim.play("jump")
	elif move_input != 0: 
		anim.play("walk")
	else:
		anim.play("idle")
	
func take_damage(amount: int):
	play_sound(take_damage_sfx)
	health -= amount 
	OnUpdateHealth.emit(health)
	damage_flash()
	if health <= 0:
		call_deferred("game_over")
	
func game_over():
	PlayerStats.score = 0
	get_tree().change_scene_to_file("res://menu.tscn")
	
func increase_score (amount : int):
	play_sound(coin_sfx)
	
	PlayerStats.score += amount
	OnUpdateScore.emit(PlayerStats.score)	

func damage_flash():
	sprite.modulate = Color.RED
	await get_tree().create_timer(0.05).timeout
	sprite.modulate = Color.WHITE
	
func play_sound(sound : AudioStream):
	audio.stream = sound
	audio.volume_db = -10
	audio.play()
