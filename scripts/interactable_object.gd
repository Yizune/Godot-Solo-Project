extends Node2D

@export var target_scene: String = ""
@export var transition_text: String = "Entering..."
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

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		_interact()

func _interact():
	if target_scene != "":
		print("Transitioning to:", target_scene)
		var scene_loader = get_tree().get_first_node_in_group("SceneLoader") as Node
		print("Found SceneLoader:", scene_loader)
		
		if scene_loader and scene_loader.has_method("start_transition"):
			scene_loader.start_transition(target_scene, transition_text)
		else:
			print("SceneLoader not found or missing script!")
	else:
		print("No scene set for this object!")
