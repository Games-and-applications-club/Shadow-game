extends StaticBody2D

@onready var shadow = $"../Shadow_Character"

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Main_Character":
		shadow.visible = true
		shadow.set_collision_layer_value(2, true)
		shadow.set_collision_layer_value(3, false)
