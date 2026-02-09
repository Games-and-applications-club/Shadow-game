extends Node2D
func _ready() -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("Assets/Scenes/LevelPicker.tscn")


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("Assets/Scenes/OptionsMenu.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
