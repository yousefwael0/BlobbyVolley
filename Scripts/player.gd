class_name Player
extends RigidBody2D

enum Controls {Blue_Player, Red_Player}
@export var player : Controls
@export var player_sprite : Texture2D

signal ball_touched

const SPEED := 245.0
const JUMP_VELOCITY := -6600.0

func _ready():
	$Sprite2D.texture = player_sprite
	lock_rotation = true
	gravity_scale = 1.2

func _physics_process(delta):
	match player:
		Controls.Red_Player:
			var direction := Input.get_axis("Left", "Right")
			move(direction, delta)
			if Input.is_action_just_pressed("Up"):
				jump()
		
		Controls.Blue_Player:
			var direction := Input.get_axis("A", "D")
			move(direction, delta)
			if Input.is_action_just_pressed("W"):
				jump()

func move(direction, delta):
	if direction:
		linear_velocity.x = direction * SPEED
	else:
		linear_velocity.x = move_toward(linear_velocity.x, 0, SPEED)

func jump():
	if is_grounded():
		apply_central_force(Vector2(0, JUMP_VELOCITY))

func is_grounded() -> bool: 
	if $RayCast2D.is_colliding():
		return true
	else:
		return false

func _on_body_entered(body):
	if body is Ball:
		ball_touched.emit()
