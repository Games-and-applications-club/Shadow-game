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
	var master_index = AudioServer.get_bus_index("Master")
	var should_mute = value <= 0.6

	AudioServer.set_bus_mute(master_index, should_mute)
	if not should_mute:
		AudioServer.set_bus_volume_db(master_index, db)

	# Optional: mute Music and SFX if Master is low
	for bus_name in ["Music", "SFX"]:
		var index = AudioServer.get_bus_index(bus_name)
		AudioServer.set_bus_mute(index, should_mute)

	settings.save_volume_settings(value, music_slider.value, sfx_slider.value, mute_toggle.button_pressed)
	print_debug("Master vol changed to:", value)


func _on_music_slider_value_changed(value: float) -> void:
	var db = volume_to_db(value)
	var music_index = AudioServer.get_bus_index("Music")
	var should_mute = value <= 0.6

	AudioServer.set_bus_mute(music_index, should_mute)
	if not should_mute:
		AudioServer.set_bus_volume_db(music_index, db)

	settings.save_volume_settings(master_slider.value, value, sfx_slider.value, mute_toggle.button_pressed)


func _on_sfx_slider_value_changed(value: float) -> void:
	var db = volume_to_db(value)
	var sfx_index = AudioServer.get_bus_index("SFX")
	var should_mute = value <= 0.6

	AudioServer.set_bus_mute(sfx_index, should_mute)
	if not should_mute:
		AudioServer.set_bus_volume_db(sfx_index, db)

	settings.save_volume_settings(master_slider.value, music_slider.value, value, mute_toggle.button_pressed)


func _on_mute_toggle_toggled(toggled_on: bool) -> void:
	var master_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(master_index, toggled_on)
	settings.save_volume_settings(master_slider.value, music_slider.value, sfx_slider.value, toggled_on)


func volume_to_db(value: float) -> float:
	if value <= 0.6:
		return -80.0  # Full mute
	var normalized = clamp((value - 0.6) / (1.2 - 0.6), 0.0, 1.0)
	return lerp(-40.0, 0.0, normalized)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")
