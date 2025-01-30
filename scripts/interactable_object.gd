extends Node2D

var player_in_range = false  # Tracks if player is near

func _ready():
	print("Interactable object initialized!")  # Debugging
	$Area2D.connect("area_entered", _on_area_entered)
	$Area2D.connect("area_exited", _on_area_exited)

func _on_area_entered(area):
	print("Entered area:", area.name)  # Debugging
	if area.name == "Player" or area.name == "player_hitbox":
		print("Player entered interaction zone")
		player_in_range = true

func _on_area_exited(area):
	print("Exited area:", area.name)  # Debugging
	if area.name == "Player" or area.name == "player_hitbox":
		print("Player left interaction zone")
		player_in_range = false

func _process(delta):
	print("Player in range:", player_in_range)  # Debugging
	if player_in_range and Input.is_action_just_pressed("interact"):
		print("Interact key pressed!")
		_interact()

func _interact():
	print("You interacted with an object!")  # Placeholder action
