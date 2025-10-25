extends Node2D

@onready var master_slider = $VBoxContainer/MasterSlider
@onready var music_slider = $VBoxContainer/MusicSlider
@onready var sfx_slider = $VBoxContainer/SFXSlider
@onready var mute_toggle = $VBoxContainer/MuteToggle

@onready var settings = preload("res://OptionsMenu/SaveSettings.gd").new()

func _ready():
	var volumes = settings.load_volume_settings()
	master_slider.value = volumes.master_volume
	music_slider.value = volumes.music_volume
	sfx_slider.value = volumes.sfx_volume
	mute_toggle.button_pressed = volumes.is_muted


	# Apply initial volumes
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), lerp(-80, 0, master_slider.value))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), lerp(-80, 0, music_slider.value))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), lerp(-80, 0, sfx_slider.value))

	# Connect sliders
	master_slider.connect("value_changed", Callable(self, "_on_master_slider_value_changed"))
	music_slider.connect("value_changed", Callable(self, "_on_music_slider_value_changed"))
	sfx_slider.connect("value_changed", Callable(self, "_on_sfx_slider_value_changed"))
	mute_toggle.connect("toggled", Callable(self, "_on_mute_toggled"))

func _on_master_slider_value_changed(value: float) -> void:
	var db = volume_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db)

	var should_mute = value <= 0.6
	for bus_name in ["Music", "SFX"]:
		AudioServer.set_bus_mute(AudioServer.get_bus_index(bus_name), should_mute)

	settings.save_volume_settings(value, music_slider.value, sfx_slider.value, mute_toggle.button_pressed)
	print_debug("Master vol changed to:",value)
func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), lerp(-80, 0, value))
	settings.save_volume_settings(master_slider.value, value, sfx_slider.value, mute_toggle.button_pressed)

func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), lerp(-80, 0, value))
	settings.save_volume_settings(master_slider.value, music_slider.value, value, mute_toggle.button_pressed)


func _on_mute_toggle_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), toggled_on)
	settings.save_volume_settings(master_slider.value, music_slider.value, sfx_slider.value, toggled_on)

func volume_to_db(value: float) -> float:
	if value <= 0.6:
		return -80.0  # Full mute
	# Normalize the range from 0.6–1.2 to 0–1
	var normalized = (value - 0.6) / (1.2 - 0.6)
	return lerp(-40.0, 0.0, normalized)  # Adjust -40 to taste


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")
