extends CharacterBody2D

var enemy_att_range = false
var enemy_att_cd = true
var health = 200
var player_alive = true

var attack_in_progress = false
var shooting_arrow = false  # Prevents multiple arrow spawns

const speed = 100
var current_dir = Vector2.ZERO

@onready var tutorial_ui = get_parent().get_node("TutorialUI")  # Tutorial UI
@export var arrow_scene: PackedScene  # Assign the arrow scene in the inspector
@onready var anim = $AnimatedSprite2D

func _ready():
	anim.play("1idle")

	# Ensure arrow_scene is assigned
	if arrow_scene == null:
		print("🚨 ERROR: arrow_scene is NULL! Assign it in the Inspector.")
	else:
		print("✅ Arrow Scene assigned correctly:", arrow_scene.resource_path)

	await get_tree().process_frame  # Ensure scene is fully loaded before setting position

	var spawn_point = get_parent().get_node("PlayerSpawn")
	if spawn_point:
		global_position = spawn_point.global_position
	else:
		print("ERROR: PlayerSpawn not found!")

func _physics_process(delta: float) -> void:
	player_movement(delta)
	attack()
	enemy_attack()

	if health <= 0:
		player_alive = false
		health = 0
		print("player is dead")
		anim.play("1death")
		await anim.animation_finished
		self.queue_free()

func _input(event):
	if event.is_action_pressed("show_tutorial"):
		tutorial_ui.show_tutorial()

func player_movement(delta):
	if attack_in_progress:
		return  # Stop movement while attacking

	var input_dir = Vector2.ZERO

	# WASD movement
	if Input.is_action_pressed("move_right"):
		input_dir.x += 1
	if Input.is_action_pressed("move_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("move_down"):
		input_dir.y += 1
	if Input.is_action_pressed("move_up"):
		input_dir.y -= 1

	# Normalize direction for smooth movement
	if input_dir.length() > 0:
		current_dir = input_dir.normalized()
		play_anim("1walk")
	else:
		play_anim("1idle")

	velocity = input_dir.normalized() * speed
	move_and_slide()

func play_anim(anim_name):
	if attack_in_progress:
		return  # Don't interrupt attacks
	anim.play(anim_name)

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_att_range = true

func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_att_range = false

func enemy_attack():
	if enemy_att_range and enemy_att_cd:
		health -= 20
		enemy_att_cd = false
		anim.play("1take_damage")
		$attack_cd.start()
		print(health)

func _on_attack_cd_timeout() -> void:
	enemy_att_cd = true

func attack():
	if attack_in_progress:
		return

	if Input.is_action_just_pressed("attack"):
		print("⚔️ Melee attack triggered!")
		attack_in_progress = true
		anim.play("attack1")
		await anim.animation_finished
		attack_in_progress = false

	elif Input.is_action_just_pressed("attack_range") and not shooting_arrow:
		print("🏹 Arrow attack triggered!")
		attack_in_progress = true
		shooting_arrow = true
		anim.play("attack3")

		# Wait for animation to complete before shooting
		await anim.animation_finished
		shoot_arrow()

		# Reset attack state
		attack_in_progress = false
		shooting_arrow = false

func shoot_arrow():
	print("⚡ shoot_arrow() TRIGGERED!")  

	if arrow_scene == null:
		print("🚨 ERROR: arrow_scene is NULL! Assign it in Inspector.")
		return

	print("✅ Instantiating arrow...")  
	var arrow_instance = arrow_scene.instantiate()

	if not arrow_instance is Area2D:
		print("🚨 ERROR: Arrow instance is NOT an Area2D! Instead, it is:", arrow_instance)
		return

	print("✅ Arrow instantiated correctly!")  

	# Position arrow at player
	arrow_instance.global_position = global_position  

	# Get mouse position and set direction
	var mouse_position = get_global_mouse_position()
	var shoot_dir = (mouse_position - global_position).normalized()
	arrow_instance.set_direction(shoot_dir)

	# Add the arrow to the scene
	get_tree().current_scene.add_child(arrow_instance)
	print("🏹 Arrow fired towards:", mouse_position, "Direction:", shoot_dir)  

func _on_deal_attack_timer_timeout() -> void:
	$deal_attack_timer.stop()
	attack_in_progress = false
