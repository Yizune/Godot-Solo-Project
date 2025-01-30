extends CharacterBody2D

var speed = 45
var player_chase = false
var player = null

var health = 100
var player_in_attack_zone = false

var can_take_dmg = true

func _physics_process(delta: float) -> void:
	deal_with_damage()
	
	if player_chase:
		position += (player.position - position) / speed
		
		$AnimatedSprite2D.play("side_walk")
		
		if(player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		

func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false
	
func enemy():
	pass


func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_attack_zone = true


func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_attack_zone = false

func deal_with_damage():
	if player_in_attack_zone == true and Global.player_current_attack == true:
		if can_take_dmg == true:
			health -= 20
			$take_damage_cd.start()
			can_take_dmg = false
			print("slime health = ", health)
			if health <= 0:
				self.queue_free()


func _on_take_damage_cd_timeout() -> void:
	can_take_dmg = true
