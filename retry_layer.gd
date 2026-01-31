extends CanvasLayer

@onready var color_rect: ColorRect= $ColorRect
@onready var label: Label = $Label
@onready var button = $RetryButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	color_rect.color.a = 0.0
	label.modulate.a = 0.0
	label.text = "Day %s" % Global.day


func fade(target_alpha: float, duration: float = 1.0):
	var tween = create_tween()
	tween.tween_property(color_rect, "color:a", target_alpha, duration)
	return tween

func label_fade(target_alpha: float, duration: float = 1.0):
	var tween = label.create_tween()
	tween.tween_property(label, "modulate:a", target_alpha, duration)
	return tween
	
