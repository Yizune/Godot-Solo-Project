# scene_loader.gd
extends Node

@onready var animation_player = $Control/AnimationPlayer
@onready var color_rect = $Control/ColorRect
@onready var label = $Control/Label
var next_scene_path = ""
var is_transitioning = false

func _ready():
	add_to_group("SceneLoader")
	animation_player.root_node = animation_player.get_parent().get_path()
	
	print("Available animations:", animation_player.get_animation_list())
	
	color_rect.modulate.a = 0
	label.modulate.a = 0
	color_rect.visible = false
	label.visible = false

func start_transition(target_scene: String, transition_text: String):
	if is_transitioning:
		return
		
	is_transitioning = true
	next_scene_path = target_scene
	label.text = transition_text
	
	color_rect.visible = true
	label.visible = true
	color_rect.modulate.a = 0
	label.modulate.a = 0
	
	animation_player.play("fade_transition")
	
	await get_tree().create_timer(animation_player.current_animation_length / 2.0).timeout
	
	_load_new_scene()

func _load_new_scene():
	for child in get_tree().current_scene.get_children():
		if child != self:
			child.queue_free()
			
	await get_tree().process_frame
	
	var new_scene = ResourceLoader.load(next_scene_path)
	if new_scene:
		var instance = new_scene.instantiate()
		get_tree().current_scene.add_child(instance)
		get_tree().current_scene = instance
		
		await animation_player.animation_finished
		_reset()
	else:
		print("Failed to load scene:", next_scene_path)

func _reset():
	color_rect.visible = false
	label.visible = false
	is_transitioning = false
	print("Scene transition completed")
