extends StaticBody2D

@export var falling_objects = ["rock", "carton", "rock"]
@export var lever: Node2D

@onready var rock_scene: PackedScene = preload("res://Assets/Scenes/rock.tscn")
@onready var carton_scene: PackedScene = preload("res://Assets/Scenes/carton.tscn")

var max = falling_objects.size()

func drop(i):
	var obj = falling_objects[i]
	if obj == "rock":
		rock()
	elif obj == "carton":
		carton()
	else:
		print("Error, wrong object name!")

func rock():
	var rock = rock_scene.instantiate()
	rock.position = position + Vector2(0, 10)
	get_tree().current_scene.add_child(rock)
	
func carton():
	var carton = carton_scene.instantiate()
	carton.position = position + Vector2(0, 10)
	get_tree().current_scene.add_child(carton)
