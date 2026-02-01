extends Node2D

@export var raise_height := -128.0
@export var move_speed := 6.0

var closed_y := 0.0
var open_y := 0.0
var target_y := 0.0

func _ready():
	closed_y = position.y
	open_y = closed_y + raise_height
	target_y = closed_y
	print("Door ready at y:", closed_y)

func _physics_process(delta):
	position.y = lerp(position.y, target_y, delta * move_speed)

func raise_door():
	print("raise_door called")
	target_y = open_y

func lower_door():
	print("lower_door called")
	target_y = closed_y
