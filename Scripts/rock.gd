extends RigidBody2D

var touched = 0

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Main_Character":
		touched += 1
		break_rock()
		
func break_rock():
	if touched >=3:
		queue_free()
