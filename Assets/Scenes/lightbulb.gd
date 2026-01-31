extends StaticBody2D

@onready var shadow = $"../Shadow_Character"

var collision = null

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Main_Character":
		shadow.visible = true
		collision = body.get_node("CollisionShape2D")
		collision.disabled = false
