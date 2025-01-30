extends Node2D

@export var target_scene: String = "" 

var player_in_range = false  
func _ready():
	$Area2D.connect("area_entered", _on_area_entered)
	$Area2D.connect("area_exited", _on_area_exited)

func _on_area_entered(area):
	if area.name == "player_hitbox":
		player_in_range = true

func _on_area_exited(area):
	if area.name == "player_hitbox":
		player_in_range = false

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		_interact()

func _interact():
	if target_scene != "":
		print("Loading new scene:", target_scene)
		get_tree().change_scene_to_file(target_scene)  
	else:
		print("No scene set for this object!")
