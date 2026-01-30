extends Node2D

@onready var layer = $CanvasLayer
@onready var button = layer.button

func _ready() -> void:
	Global.movable = false
	if (Global.day < 2):
		
		await layer.fade(1.0, 0).finished
		await layer.label_fade(1.0, 1.0).finished		
		await layer.label_fade(0.0, 1.0).finished
		await layer.fade(0.0, 1.5).finished
		Global.movable = true
