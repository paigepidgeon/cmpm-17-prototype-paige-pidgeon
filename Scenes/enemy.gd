extends CharacterBody2D
class_name enemy 

var speed = 130
var player_chase = false
var player = null
var is_hit = false

var enemyHealth : int = 10

@onready var health_bar : TextureProgressBar = $healthbar
@onready var damage_splash : ColorRect = $DamageSplash
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	health_bar.max_value = enemyHealth
	health_bar.value = enemyHealth
	animated_sprite.play("enemy_hop")

func take_damage (amount: int) -> void:
	enemyHealth -= amount
	update_health_ui()
	
	show_damage(amount)
	start_hit_cooldown()
	
	if enemyHealth <= 0:
		die()

func update_health_ui() -> void:
	health_bar.value = enemyHealth
	if enemyHealth <= 0:
		health_bar.visible = false 

func show_damage(amount: int) -> void:
	damage_splash.modulate = Color.RED if amount == 2 else Color (1, 0.5, 0)
	damage_splash.visible = true

func start_hit_cooldown() -> void: 
		is_hit = true
		is_hit = false
		damage_splash.visible = false

func die() -> void:
		queue_free()

func get_health() -> int:
	return enemyHealth

func _physics_process(delta):
		if player_chase:
			position += (player.position - position)/speed
			move_and_slide()
		
		
			if velocity.length() >0:
					$AnimatedSprite2D.play("enemy_hop")
					animated_sprite.flip_h = velocity.x < 0
		else:
					velocity = Vector2.ZERO
					animated_sprite.play("enemy_hop")
		
		
func _on_detection_area_body_entered(body):
	player = body
	player_chase = true
	print ("detected")
	
func _on_detection_area_body_exited(body):
	player = null

	player_chase = false
	print("exited")
