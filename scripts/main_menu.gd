#extends Control
#
#@onready var menu = $Menu
#@onready var new_game_button = $Menu/NewGame
#@onready var continue_button = $Menu/Continue
#@onready var settings_button = $Menu/Settings
#@onready var exit_button = $Menu/Exit
#
#@onready var settings = $Settings
#@onready var sound = $Settings/Sound
#@onready var back_button = $Settings/Back
#
#@onready var master_slider = $Sound/Master
#@onready var music_slider = $Sound/Music
#@onready var effects_slider = $Sound/Effects
#@onready var back_button2 = $Sound/Back
#
#@onready var click_audio = $ClickAudio
#@onready var animation_player = $MenuAnimationPlayer
#
#func _ready():
		## Ensure visibility is set correctly
	#menu.visible = true
	#settings.visible = false
	#sound.visible = false
	#
	## Debug initial setup
	#print("\n==== MENU LOADED ====")
	#print("Menu:", menu)
	#print("Sound Settings:", settings)
	#print("Sound:", sound)
#
	## Ensure sliders are set correctly
	#master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	#music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	#effects_slider.value = db_to_linear(AudioServer.get_bus_volume_db(2))
#
	## Debug sliders
	#print("Master Slider:", master_slider.value)
	#print("Music Slider:", music_slider.value)
	#print("Effects Slider:", effects_slider.value)
	#
		## Debug node hierarchy
	#print("\nNode Hierarchy Check:")
	#print("Settings parent:", settings.get_parent().name)
	#print("Sound parent:", sound.get_parent().name)
	#print("Settings rect:", settings.get_rect())
	#print("Sound rect:", sound.get_rect())
	#
	## Verify z-index
	#print("\nZ-Index Check:")
	#print("Settings z-index:", settings.z_index)
	#print("Sound z-index:", sound.z_index)
#
## =============================
## 🎮 Button Functions
## =============================
#

#
## Continue Game
#func _on_Continue_pressed():
	#_play_click_sound()
	#print("Continue button pressed. Load last saved game...")  # Implement actual load logic here
#
#func _on_Settings_pressed():
	#_play_click_sound()
	#print("Settings button pressed!")
	#
	#if not settings or not menu:
		#print("ERROR: Nodes are missing! Check Scene Tree.")
		#return
	#
	## Store the original visibility states
	#var original_menu_visible = menu.visible
	#var original_settings_visible = settings.visible
	#
	## Make the change
	#menu.visible = false
	#settings.visible = true
	#
	## Debug visibility states immediately after change
	#print("\nVisibility Check:")
	#print("Before - Menu:", original_menu_visible, " Settings:", original_settings_visible)
	#print("After - Menu:", menu.visible, " Settings:", settings.visible)
	#print("Menu parent visible:", menu.get_parent().visible)
	#print("Settings parent visible:", settings.get_parent().visible)
#
#func _on_Sound_pressed():
	#_play_click_sound()
	#print("Sound button pressed!")
	#
	#if not sound or not settings:
		#print("ERROR: Sound settings node missing!")
		#return
	#
	## First hide settings, then show sound
	#settings.visible = false
	#sound.visible = true
	#
	## Debug visibility states
	#print("Settings visibility:", settings.visible)
	#print("Sound visibility:", sound.visible)
	#print("Sound global position:", sound.global_position)
#
## Back Button (Close Sound Settings)
#func _on_Back_pressed():
	#_play_click_sound()
	#print("Back button pressed. Returning to Menu...")
	#menu.visible = true
	#settings.visible = false
#
#func _on_Back2_pressed():
	#_play_click_sound()
	#print("Back button 2 pressed. Returning to Sound Settings...")
	#settings.visible = true
	#sound.visible = false
#
## Exit the game
#func _on_Exit_pressed():
	#_play_click_sound()
	#print("Exit button pressed. Quitting game...")
	#get_tree().quit()
#


extends Control

@onready var menu = $Menu
@onready var settings = $Settings
@onready var sound = $Sound
@onready var click_audio = $ClickAudio

func _ready():
	# Start with only menu visible
	show_only_menu()

func show_only_menu():
	menu.show()
	settings.hide()
	sound.hide()
	print("Showing only menu")

func show_only_settings():
	menu.hide()
	settings.show()
	sound.hide()
	print("Showing only settings")

func show_only_sound():
	menu.hide()
	settings.hide()
	sound.show()
	print("Showing only sound")
	
# Start a new game
func _on_NewGame_pressed():
	play_click_sound()
	print("New Game button pressed. Loading new scene...")
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_Settings_pressed():
	play_click_sound()
	show_only_settings()

func _on_Sound_pressed():
	play_click_sound()
	show_only_sound()

func _on_Back_pressed():
	play_click_sound()
	show_only_menu()
	
func _on_Back2_pressed():
	play_click_sound()
	show_only_settings()
	
func _on_Exit_pressed():
	play_click_sound()
	print("Exit button pressed. Quitting game...")
	get_tree().quit()

#func _on_Back2_pressed():
	#play_click_sound()
	#show_only_settings()
	
## =============================
## 🎵 Audio Functions
## =============================
#
# Adjust Master Volume
func _on_Master_value_changed(value):
	print("Master Volume Changed:", value)
	AudioServer.set_bus_volume_db(0, linear_to_db(value))

# Adjust Music Volume
func _on_Music_value_changed(value):
	print("Music Volume Changed:", value)
	AudioServer.set_bus_volume_db(1, linear_to_db(value))

# Adjust Effects Volume
func _on_Effects_value_changed(value):
	print("Effects Volume Changed:", value)
	AudioServer.set_bus_volume_db(2, linear_to_db(value))

func play_click_sound():
	if click_audio:
		click_audio.play()
