extends Area2D

@onready var shadow = $"../Shadow_Character"

var collision = null

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Main_Character":
		shadow.visible = false
		collision = body.get_node("CollisionShape2D")
		collision.disabled = true
