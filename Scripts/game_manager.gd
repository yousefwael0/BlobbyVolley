extends Node2D

var blue_score := 0
var red_score := 0
var paused := false

@export var blue_spawn : Marker2D
@export var red_spawn : Marker2D
@export var score : Control
@export var pause_menu : Control

const BALL = preload("res://Scenes/ball.tscn")

func _ready():
	var ball = BALL.instantiate()
	ball.position = red_spawn.position
	ball.scored.connect(scored)
	add_child(ball)
	pause_menu.get_node("Panel/MarginContainer/VBoxContainer/Resume").pressed.connect(resumed)
	pause_menu.get_node("Panel/MarginContainer/VBoxContainer/MainMenu").pressed.connect(back_to_main_menu)
	pause_menu.get_node("Panel/MarginContainer/VBoxContainer/Quit").pressed.connect(quited)

func _unhandled_input(event):
	if event.is_action_pressed("Pause"):
		toggle_pause_menu()

func update_scores():
	score.blue_label.text = str(blue_score)
	score.red_label.text = str(red_score)

func scored(player : Player.Controls):
	var ball := BALL.instantiate()
	ball.scored.connect(scored)
	match player:
		Player.Controls.Blue_Player:
			print("RED SCORED!")
			red_score += 1
			update_scores()
			ball.position = red_spawn.position
		Player.Controls.Red_Player:
			print("BLUE SCORED!")
			blue_score += 1
			update_scores()
			ball.position = blue_spawn.position
	add_child(ball)

func toggle_pause_menu():
	if paused:
		paused = !paused
		pause_menu.hide()
		get_tree().paused = paused
	else:
		paused = !paused
		pause_menu.show()
		get_tree().paused = paused

func resumed():
	toggle_pause_menu()

func back_to_main_menu():
	toggle_pause_menu()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func quited():
	get_tree().quit()
