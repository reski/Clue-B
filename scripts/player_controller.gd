extends CharacterBody2D

@export var walking_speed: float = 1

func _process(delta: float) -> void:
	velocity.x = 0
	velocity.y = 0

	if Input.is_action_pressed("ui_left"):
		velocity.x = -walking_speed
	elif Input.is_action_pressed("ui_right"):
		velocity.x = walking_speed
	if Input.is_action_pressed("ui_up"):
		velocity.y = -walking_speed
	if Input.is_action_pressed("ui_down"):
		velocity.y = walking_speed

	move_and_collide(velocity)

func _physics_process(delta: float) -> void:
	pass
