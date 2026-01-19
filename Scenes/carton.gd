extends RigidBody2D


func _physics_process(delta):
	if linear_velocity.length() > 0.1:
		print("BLOCK MOVING:", linear_velocity)
