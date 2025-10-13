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

	_apply_mute(volumes.is_muted)
	_apply_volume()

	master_slider.connect("value_changed", Callable(self, "_on_volume_changed"))
	music_slider.connect("value_changed", Callable(self, "_on_volume_changed"))
	sfx_slider.connect("value_changed", Callable(self, "_on_volume_changed"))
	mute_toggle.connect("toggled", Callable(self, "_on_mute_toggled"))

func _on_volume_changed(value):
	_apply_volume()
	settings.save_volume_settings(
		master_slider.value,
		music_slider.value,
		sfx_slider.value,
		mute_toggle.button_pressed
	)

func _on_mute_toggled(button_pressed):
	_apply_mute(button_pressed)
	settings.save_volume_settings(
		master_slider.value,
		music_slider.value,
		sfx_slider.value,
		button_pressed
	)

func _apply_volume():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -80 if master_slider.value <= 0.01 else 0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -80 if music_slider.value <= 0.01 else 0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), -80 if sfx_slider.value <= 0.01 else 0)

func _apply_mute(mute):
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), mute)
