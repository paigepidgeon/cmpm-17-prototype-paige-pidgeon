extends CharacterBody2D
class_name player

@export var speed : float = 130
@export var acceleration : float = 0.05
@export var deceleration : float = 0.05
@onready var hit_box: Area2D = $hitbox
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var isAttacking = false
var gallopCounter = 0
var playerHealth : int = 20
var maxHealth : int = 20

func _ready() -> void:
	hit_box.monitoring = false

func _physics_process(_delta: float) -> void:
	move_and_slide()
	update_animation()
	get_input()

func get_input() -> void:
	if Input.is_action_just_pressed("Gallop") and not isAttacking:
		hit_box.monitoring = true
		isAttacking = true
		animated_sprite.play("gallop")
		gallopCounter += 1

	if Input.is_action_just_pressed("horsepower") and not isAttacking and gallopCounter >= 2:
		hit_box.monitoring = true
		isAttacking = true
		animated_sprite.play("horsepower")
		gallopCounter = 0

	if Input.is_action_pressed("D"):
		velocity.x = lerp(velocity.x, speed, acceleration)
		animated_sprite.flip_h = false
	if Input.is_action_pressed("A"):
		velocity.x = lerp(velocity.x, -speed, acceleration)
		animated_sprite.flip_h = true
	else:
		velocity.x = lerp(velocity.x, 0.0, deceleration)

	if Input.is_action_pressed("S"):
		velocity.y = lerp(velocity.y, speed, acceleration)
	elif Input.is_action_pressed("W"):
		velocity.y = lerp(velocity.y, -speed, acceleration)
	else:
		velocity.y = lerp(velocity.y, 0.0, deceleration)

func update_animation() -> void:
	if isAttacking:
		pass
	elif velocity.length() > 0:
		animated_sprite.play("player_walk")
	else:
		animated_sprite.frame = 0

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "gallop":
		isAttacking = false
		hit_box.monitoring = false
	elif animated_sprite.animation == "horsepower":
		isAttacking = false
		hit_box.monitoring = false

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "enemy" and body.has_method("take_damage"):
		if animated_sprite.animation == "horsepower":
			body.take_damage(2)
		else:
			body.take_damage(1)
	elif body.name == "enemy":
		take_damage(2)

func take_damage(amount: int) -> void:
	playerHealth -= amount
	playerHealth = max(playerHealth, 0)
	if playerHealth <= 0:
		player_died()

func player_died() -> void:
	queue_free()
