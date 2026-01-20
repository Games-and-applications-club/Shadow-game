extends Control


func _on_button_pressed() -> void:
	reloadScene()

func reloadScene():
	get_tree().reload_current_scene()
