extends CharacterBody2D
class_name enemy

var speed = 20
var player_chase = false
var player_reference = null
var is_hit = true
var enemyHealth: int = 10
var attack_damage = 2  

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

	
	for body in get_slide_collision_count():
		var collision = get_slide_collision(body)
		if collision.get_collider().is_in_group("player"):
			$AnimatedSprite2D.play("sploink")
			collision.get_collider().take_damage(attack_damage)

func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		player_reference = body
		player_chase = true

func _on_detection_area_body_exited(body):
	if body.is_in_group("player"):
		player_reference = null
		player_chase = false
