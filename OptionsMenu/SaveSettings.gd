# SaveSettings.gd
extends Node

var config = ConfigFile.new()
const SETTINGS_PATH = "user://settings.cfg"

func save_volume_settings(master, music, sfx, is_muted = false):
	config.set_value("audio", "master_volume", master)
	config.set_value("audio", "music_volume", music)
	config.set_value("audio", "sfx_volume", sfx)
	config.set_value("audio", "is_muted", is_muted)
	config.save(SETTINGS_PATH)

func load_volume_settings():
	var err = config.load(SETTINGS_PATH)
	if err != OK:
		return {
			"master_volume": 1.0,
			"music_volume": 1.0,
			"sfx_volume": 1.0,
			"is_muted": false
		}
	return {
		"master_volume": config.get_value("audio", "master_volume", 1.0),
		"music_volume": config.get_value("audio", "music_volume", 1.0),
		"sfx_volume": config.get_value("audio", "sfx_volume", 1.0),
		"is_muted": config.get_value("audio", "is_muted", false)
	}
