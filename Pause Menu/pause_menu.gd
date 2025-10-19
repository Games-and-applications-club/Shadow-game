extends Control

func resume():
	get_tree().paused=false
	$AnimationPlayer.play_backwards("Blur")
func pause():
	get_tree().paused=true
	$AnimationPlayer.play("Blur")
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Pause"):
		if get_tree().paused:
			resume()
		else:
			pause()


func _on_resume_pressed() -> void:
	resume()

func _on_options_pressed() -> void:
	pass # You'll handle this separately

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
