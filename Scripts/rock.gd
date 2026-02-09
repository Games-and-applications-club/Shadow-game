extends RigidBody2D

var player = false
var shadow = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Main_Character":
		player = true
	if body.name == "Shadow_Character":
		shadow = true
	if player and shadow:
		break_rock()
		
func break_rock():
	queue_free()
