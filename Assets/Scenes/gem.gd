extends Area2D

@export var happyEndingDate: int = 20

@onready var layer = $"../RetryLayer"
@onready var button = layer.button

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Main_Character":
		#if Global.day > 0happyEndingDate:
		await layer.fade(1.0, 1.5).finished
		get_tree().change_scene_to_file("res://Scenes/BadEnding.tscn")
		#else:
			#get_tree().change_scene_to_file("res://Scenes/happyEnding.tscn")
