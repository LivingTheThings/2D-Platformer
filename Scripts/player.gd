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
var move_input : float 
var debloat: bool = true
@onready var sprite : Sprite2D = $Sprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var tile_map: TileMapLayer = $"../TileMapLayer"
@export var health : int = 3

var is_climb = false
var take_damage_sfx : AudioStream = preload("res://Audio/take_damage.wav")
var coin_sfx : AudioStream = preload("res://Audio/coin.wav")

func _physics_process(delta: float) -> void:
	var climb_input = Input.get_axis("jump", "climb_down")
	var bool_damage = tile_map.touched_spike(global_position)
	var bool_climb = tile_map._on_ladder_on_player(global_position)
	var is_damage = true
	move_input = Input.get_axis("move_left", "move_right")

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

	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = -jump_force
	
	move_and_slide()	
	
	if move_input != 0:
		velocity.x = lerp(velocity.x, move_input * move_speed, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, braking * delta)
		
	if bool_damage:
		is_damage = true
		
	if is_damage:
		debloat = false
		await get_tree().create_timer(5).timeout
		debloat = true
		if debloat == true:
			debloat = false
			print('hjel')
			pass
		pass
	
		
	




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
