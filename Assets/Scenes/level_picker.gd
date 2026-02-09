extends Node2D

func _on_level_1_button_pressed() -> void:
	get_tree().change_sceen_to_file("res://Scenes/testMap.tscn")


func _on_level_2_button_pressed() -> void:
	pass # Replace with function body.


func _on_level_3_button_pressed() -> void:
	pass # Replace with function body.


func _on_level_4_button_pressed() -> void:
	pass # Replace with function body.


func _on_level_5_button_pressed() -> void:
	pass # Replace with function body.


func _on_level_6_button_pressed() -> void:
	pass # Replace with function body.


func _on_level_7_button_pressed() -> void:
	pass # Replace with function body.


func _on_level_8_button_pressed() -> void:
	pass # Replace with function body.


func _on_exit_button_pressed() -> void:
	print("Back to main menu")
	get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")
