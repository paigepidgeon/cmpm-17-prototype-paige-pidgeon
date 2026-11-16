extends CharacterBody2D
class_name enemy

var speed = 130
var player_chase = false
var player_reference = null
var is_hit = false
var enemyHealth: int = 10

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	animated_sprite.play("enemy_hop")

func take_damage(amount: int) -> void:
	enemyHealth -= amount
	if enemyHealth <= 0:
		die()

func die() -> void:
	queue_free()

func get_health() -> int:
	return enemyHealth

func _physics_process(delta):
	if player_chase and player_reference:
		var direction = (player_reference.position - position).normalized()
		velocity = direction * speed
		move_and_slide()
		if velocity.length() > 0:
			animated_sprite.play("enemy_hop")
			animated_sprite.flip_h = velocity.x < 0
	else:
		velocity = Vector2.ZERO
		animated_sprite.play("enemy_hop")

func _on_detection_area_body_entered(body):
	if body.name == "player":
		player_reference = body
		player_chase = true

func _on_detection_area_body_exited(body):
	if body.name == "player":
		player_reference = null
		player_chase = false
