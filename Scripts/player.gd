extends CharacterBody2D

@export var move_speed : float = 1000
@export var acceleration : float = 500
@export var braking : float = 200
@export var gravity : float = 5000
@export var jump_force : float = 2000

var move_input : float 

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	move_input = Input.get_axis("move_left", "move_right")
	velocity.x = move_input * move_speed
	move_and_slide()	
	
	if move_input != 0:
		velocity.x = lerp(velocity.x, move_input * move_speed, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, braking * delta)
		
	
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = -jump_force 
