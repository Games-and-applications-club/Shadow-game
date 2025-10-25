extends Control

@onready var pause_container = $PanelContainer/PauseContainer
@onready var options_container = $PanelContainer/OptionsContainer

@onready var master_slider = $PanelContainer/OptionsContainer/MasterVolSlider
@onready var music_slider = $PanelContainer/OptionsContainer/MusicVolSlider
@onready var sfx_slider = $PanelContainer/OptionsContainer/SFXVolSlider
@onready var mute_toggle = $PanelContainer/OptionsContainer/MuteToggle

@onready var settings = preload("res://OptionsMenu/SaveSettings.gd").new()

func _ready():
	print(master_slider, music_slider, sfx_slider, mute_toggle)
	pause_container.visible = false
	options_container.visible = false

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
	master_slider.connect("value_changed", Callable(self, "_on_master_vol_slider_changed"))
	music_slider.connect("value_changed", Callable(self, "_on_music_vol_slider_changed"))
	sfx_slider.connect("value_changed", Callable(self, "_on_sfx_vol_slider_changed"))
	mute_toggle.connect("toggled", Callable(self, "_on_mute_toggled"))

func pause():
	get_tree().paused = true
	pause_container.visible = true
	options_container.visible = false
	$AnimationPlayer.play("Blur")

func resume():
	get_tree().paused = false
	pause_container.visible = false
	options_container.visible = false
	$AnimationPlayer.play_backwards("Blur")

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Pause"):
		if get_tree().paused:
			resume()
		else:
			pause()

func _on_resume_pressed() -> void:
	resume()

func _on_options_pressed() -> void:
	pause_container.visible = false
	options_container.visible = true


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
#///////////////////////////////

func _on_back_button_pressed() -> void:
	options_container.visible = false
	pause_container.visible = true

func _on_master_vol_slider_changed(value: float) -> void:
	var db = volume_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db)

	var should_mute = value <= 0.6
	for bus_name in ["Music", "SFX"]:
		AudioServer.set_bus_mute(AudioServer.get_bus_index(bus_name), should_mute)

	settings.save_volume_settings(value, music_slider.value, sfx_slider.value, mute_toggle.button_pressed)
	print_debug("Master vol changed to:",value)

func _on_music_vol_slider_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), lerp(-80, 0, value))
	settings.save_volume_settings(master_slider.value, value, sfx_slider.value, mute_toggle.button_pressed)

func _on_sfx_vol_slider_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), lerp(-80, 0, value))
	settings.save_volume_settings(master_slider.value, music_slider.value, value, mute_toggle.button_pressed)

func _on_mute_toggle_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), toggled_on)
	settings.save_volume_settings(master_slider.value, music_slider.value, sfx_slider.value, toggled_on)

func volume_to_db(value: float) -> float:
	if value <= 0.6:
		return -80.0
	var normalized = (value - 0.6) / (1.2 - 0.6)
	return lerp(-40.0, 0.0, normalized)
