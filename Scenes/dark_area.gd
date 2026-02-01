extends Area2D

@onready var shadow = $"../../Shadow_Character"

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		shadow.visible = false
		shadow.set_collision_layer_value(2, false)
		shadow.set_collision_layer_value(3, true)
		
