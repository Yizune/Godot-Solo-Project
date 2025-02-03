extends Area2D

@export var speed: float = 500  # Arrow speed
var direction: Vector2 = Vector2.ZERO  # Direction of movement

func _ready():
	$CollisionShape2D.disabled = false  # Enable collision detection
	$Timer.start(3)  # Auto-delete after 3 seconds

func _physics_process(delta):
	if direction != Vector2.ZERO:
		position += direction * speed * delta  # Move the arrow

func set_direction(target_direction: Vector2):
	direction = target_direction.normalized()  # Normalize to ensure constant speed
	rotation = direction.angle()  # Rotate arrow to face movement direction

func _on_body_entered(body):
	if body.has_method("enemy"):  # Check if the hit object is an enemy
		body.take_damage(10)  # Call a function to damage the enemy
		queue_free()  # Remove the arrow after impact

	elif body is StaticBody2D or body is TileMap:
		queue_free()  # Remove the arrow if it hits a wall or object

func _on_Timer_timeout():
	queue_free()  # Destroy arrow after a few seconds
