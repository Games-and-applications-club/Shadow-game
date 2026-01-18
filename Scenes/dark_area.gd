extends Area2D

@onready var shadow = $"../Shadow_Character"
@onready var collision = shadow.get_node("CollisionShape2D")

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		shadow.visible = false
		collision.disabled = true
