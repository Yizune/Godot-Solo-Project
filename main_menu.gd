extends Control

@onready var menu = $Menu
@onready var new_game_button = $Menu/NewGame
@onready var continue_button = $Menu/Continue
@onready var settings_button = $Menu/Settings
@onready var exit_button = $Menu/Exit

@onready var sound_settings = $SoundSettings
@onready var sound_button = $SoundSettings/Sound
@onready var back_button = $SoundSettings/Back

@onready var master_slider = $Control/Master
@onready var music_slider = $Control/Music
@onready var effects_slider = $Control/Effects

@onready var click_audio = $ClickAudio
@onready var animation_player = $MenuAnimationPlayer

func _ready():
	sound_settings.visible = false  # Hide sound settings initially

	# Set sliders to current audio levels
	master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	effects_slider.value = db_to_linear(AudioServer.get_bus_volume_db(2))

# Start a new game
func _on_NewGame_pressed():
	_play_click_sound()
	get_tree().change_scene_to_file("res://scenes/world.tscn")

# Continue Game
func _on_Continue_pressed():
	_play_click_sound()
	print("Load last saved game...")  # Implement actual load logic here

# Open Settings
func _on_Settings_pressed():
	_play_click_sound()
	animation_player.play("show_settings")

# Open Sound Settings
func _on_Sound_pressed():
	_play_click_sound()
	sound_settings.visible = true

# Back Button (Close Sound Settings)
func _on_Back_pressed():
	_play_click_sound()
	sound_settings.visible = false

# Exit the game
func _on_Exit_pressed():
	_play_click_sound()
	get_tree().quit()

# Adjust Master Volume
func _on_Master_value_changed(value):
	AudioServer.set_bus_volume_db(0, linear_to_db(value))

# Adjust Music Volume
func _on_Music_value_changed(value):
	AudioServer.set_bus_volume_db(1, linear_to_db(value))

# Adjust Effects Volume
func _on_Effects_value_changed(value):
	AudioServer.set_bus_volume_db(2, linear_to_db(value))

# Play Click Sound
func _play_click_sound():
	if click_audio:
		click_audio.play()
