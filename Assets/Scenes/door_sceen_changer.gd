extends Node2D

var player_inside := false
var shadow_inside := false
@onready var detector := $Area2D

@export var next_scene: String = "res://Scenes/NextLevel.tscn"

func _ready():
	detector.body_entered.connect(_on_body_entered)
	detector.body_exited.connect(_on_body_exited)
	
func _on_body_entered(body):
	if body.name == "Main_Character":
		player_inside = true
	elif body.name == "Shadow_Character":
		shadow_inside = true

	_check_scene_change()

func _on_body_exited(body):
	if body.name == "Main_Character":
		player_inside = false
	if body.name == "Shadow_Character":
		shadow_inside = false

func _check_scene_change():
	if player_inside and shadow_inside:
		print("Both inside — changing scene")
		get_tree().change_scene_to_file(next_scene)
