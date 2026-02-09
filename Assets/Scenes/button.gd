extends Button

@onready var layer = $".."
@onready var label = $"../Label"
@onready var button = $"."

func _on_pressed() -> void:
	Global.day += 1
	label.text = "Day %s" % Global.day
	reloadScene()

func reloadScene():
	Global.movable = false
	await layer.fade(1.0, 1.5).finished
	await layer.label_fade(1.0, 1.0).finished
	await layer.label_fade(0.0, 1.0).finished
	await layer.fade(0.0, 1.5).finished
	Global.movable = true
	get_tree().reload_current_scene()
