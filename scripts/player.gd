#extends CharacterBody2D
#
#var enemy_att_range = false
#var enemy_att_cd = true
#var health = 200
#var player_alive = true
#
#var attack_in_progress = false
#
#const speed = 100
#var current_dir = "none"
#
#func _ready():
	#$AnimatedSprite2D.play("front_idle")
#
	#await get_tree().process_frame  # Ensure scene is fully loaded before setting position
#
	#var spawn_point = get_parent().get_node("PlayerSpawn")
	#if spawn_point:
		#global_position = spawn_point.global_position
	#else:
		#print("ERROR: PlayerSpawn not found!")
#
#
#func _physics_process(delta: float) -> void:
	#attack()
	#player_movement(delta)
	#enemy_attack()
	#
	#if health <= 0:
		#player_alive = false
		#health = 0
		#print("player is dead")
		#self.queue_free()
		##respawn/death screen here
		#
	#
#func player_movement(delta):
	#if attack_in_progress:  # Prevent movement while attacking
		#return 
	#
	#if Input.is_action_pressed("ui_right"):
		#current_dir = "right"
		#play_anim(1)
		#velocity.x = speed
		#velocity.y = 0
	#elif Input.is_action_pressed("ui_left"):
		#current_dir = "left"
		#play_anim(1)
		#velocity.x = -speed
		#velocity.y = 0
	#elif Input.is_action_pressed("ui_down"):
		#current_dir = "down"
		#play_anim(1)
		#velocity.x = 0
		#velocity.y = speed
	#elif Input.is_action_pressed("ui_up"):
		#current_dir = "up"
		#play_anim(1)
		#velocity.x = 0
		#velocity.y = -speed
	#else:
		#play_anim(0)
		#velocity.x = 0
		#velocity.y = 0
		#
	#move_and_slide()
	#
#func play_anim(movement):
	#var dir = current_dir
	#var anim = $AnimatedSprite2D
	#
	## Prevent overriding attack animations
	#if attack_in_progress:
		#return 
	#
	#if dir == "right":
		#anim.flip_h = false
		#if movement == 1:
			#anim.play("side_walk")
		#else:
			#anim.play("side_idle")
	#elif dir == "left":
		#anim.flip_h = true
		#if movement == 1:
			#anim.play("side_walk")
		#else:
			#anim.play("side_idle")
	#elif dir == "down":
		#anim.flip_h = false
		#if movement == 1:
			#anim.play("front_walk")
		#else:
			#anim.play("front_idle")
	#elif dir == "up":
		#anim.flip_h = false
		#if movement == 1:
			#anim.play("back_walk")
		#else:
			#anim.play("back_idle")									
#
#func player():
	#pass
#
#func _on_player_hitbox_body_entered(body: Node2D) -> void:
	#if body.has_method("enemy"):
		#enemy_att_range = true
#
#func _on_player_hitbox_body_exited(body: Node2D) -> void:
	#if body.has_method("enemy"):
		#enemy_att_range = false
		#
#func enemy_attack():
	#if enemy_att_range and enemy_att_cd:
		#health -= 20
		#enemy_att_cd = false
		#$attack_cd.start()
		#print(health)
#
#func _on_attack_cd_timeout() -> void:
	#enemy_att_cd = true
#
#func attack():
	#var dir = current_dir
	#var anim = $AnimatedSprite2D
	#
	#if Input.is_action_just_pressed("attack"):
		#Global.player_current_attack = true
		#attack_in_progress = true
		#
		## Set flip_h before playing animation
		#if dir == "right":
			#anim.flip_h = false
			#anim.play("side_attack")
		#elif dir == "left":
			#anim.flip_h = true
			#anim.play("side_attack")
		#elif dir == "down":
			#anim.flip_h = false
			#anim.play("front_attack")
		#elif dir == "up":
			#anim.flip_h = false
			#anim.play("back_attack")
#
		#print("Attacking:", dir, "Animation:", anim.animation, "Flip:", anim.flip_h)
		#
		#$deal_attack_timer.start()
#
#func _on_deal_attack_timer_timeout() -> void:
	#$deal_attack_timer.stop()
	#Global.player_current_attack = false
	#attack_in_progress = false

extends CharacterBody2D

var enemy_att_range = false
var enemy_att_cd = true
var health = 200
var player_alive = true

var attack_in_progress = false

const speed = 100
var current_dir = "none"

func _ready():
	$AnimatedSprite2D.play("1idle")

	await get_tree().process_frame  # Ensure scene is fully loaded before setting position

	var spawn_point = get_parent().get_node("PlayerSpawn")
	if spawn_point:
		global_position = spawn_point.global_position
	else:
		print("ERROR: PlayerSpawn not found!")

func _physics_process(delta: float) -> void:
	attack()
	player_movement(delta)
	enemy_attack()
	
	if health <= 0:
		player_alive = false
		health = 0
		print("player is dead")
		$AnimatedSprite2D.play("1death")
		await $AnimatedSprite2D.animation_finished
		self.queue_free()
		#respawn/death screen here
		
func player_movement(delta):
	if attack_in_progress:  # Prevent movement while attacking
		return 
	
	var was_moving_horizontally = current_dir == "left" or current_dir == "right"

	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(1, "right")  # Now passes both movement and direction
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_anim(1, "left")  # Now passes both movement and direction
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		velocity.x = 0
		velocity.y = speed
		if was_moving_horizontally:
			play_anim(1, current_dir)  # Uses last horizontal direction
		else:
			play_anim(1, "right")  # Default to right if no prior movement
	elif Input.is_action_pressed("ui_up"):
		velocity.x = 0
		velocity.y = -speed
		if was_moving_horizontally:
			play_anim(1, current_dir)  # Uses last horizontal direction
		else:
			play_anim(1, "right")  # Default to right if no prior movement
	else:
		play_anim(0, current_dir)  # Stops movement but keeps correct facing direction
		velocity.x = 0
		velocity.y = 0
	
	move_and_slide()


	
func play_anim(movement, direction):
	var anim = $AnimatedSprite2D

	# Prevent overriding attack animations
	if attack_in_progress:
		return 
	
	# Set the direction flip
	if direction == "right":
		anim.flip_h = false
	elif direction == "left":
		anim.flip_h = true

	# Play the correct animation
	if movement == 1:
		anim.play("1walk")
	else:
		anim.play("1idle")


func player():
	pass

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
		$AnimatedSprite2D.play("1take_damage")
		$attack_cd.start()
		print(health)

func _on_attack_cd_timeout() -> void:
	enemy_att_cd = true

func attack():
	var anim = $AnimatedSprite2D
	
	if Input.is_action_just_pressed("attack"):
		Global.player_current_attack = true
		attack_in_progress = true
		
		# Set flip_h before playing animation
		if current_dir == "right":
			anim.flip_h = false
		elif current_dir == "left":
			anim.flip_h = true
		
		anim.play("attack1")
		print("Attacking:", current_dir, "Animation:", anim.animation, "Flip:", anim.flip_h)
		$deal_attack_timer.start()

func _on_deal_attack_timer_timeout() -> void:
	$deal_attack_timer.stop()
	Global.player_current_attack = false
	attack_in_progress = false
