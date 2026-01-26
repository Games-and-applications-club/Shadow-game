extends Control

@onready var color_rect: ColorRect= $CanvasLayer/ColorRect

func _ready() -> void:
	color_rect.color.a = 0.0
	color_rect.z_index = 0

func fade(target_alpha: float, duration: float = 1.0):
	var tween = create_tween()
	tween.tween_property(color_rect, "color:a", target_alpha, duration)
	return tween

func _on_button_pressed() -> void:
	color_rect.z_index = 6
	await fade(1.0, 1.5).finished
	get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")
