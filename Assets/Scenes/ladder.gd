extends Node2D

var player_inside= false
var player = null
var climb_speed := 100.0


func _process(delta: float) -> void:
	if player_inside and player:
		if Input.is_action_pressed("jump"):
			player.position.y -= climb_speed * delta
			
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Main_Character":
		player_inside = true
		player = body
		body.set("on_ladder", true)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Main_Character":
		player_inside = false
		if player:
			player.set("on_ladder", false)
		player = null
