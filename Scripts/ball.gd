class_name Ball
extends RigidBody2D

var ball_touches_left := 3
var last_ball_touch : Player.Controls
@export var whistle_sfx : AudioStreamPlayer2D
signal scored

func _ready():
	gravity_scale = 0
	sleeping = true

func _on_body_entered(body):
	$BounceSFX.play()
	if gravity_scale != .3:
		gravity_scale = .3
	if body is Ground:
		scored.emit(body.player, self)
		body_entered.disconnect(_on_body_entered)
	elif body is Player:
		if body.player == last_ball_touch:
			if ball_touches_left > 0:
				ball_touches_left -= 1
			else:
				scored.emit(body.player, self)
				body_entered.disconnect(_on_body_entered)
		else:
			last_ball_touch = body.player
			ball_touches_left = 2
