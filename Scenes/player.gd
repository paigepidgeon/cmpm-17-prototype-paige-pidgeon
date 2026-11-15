class_name player
extends CharacterBody2D

@export var speed : float = 130
@export var acceleration : float = 0.05
@export var deceleration : float = 0.05
@onready var hit_box: Area2D = $hitbox
@onready var health_bar: TextureProgressBar = $PlayerUI/HealthBar
@onready var health_label: Label = $PlayerUI/HealthLabel

var isAttacking = false
var attackCounter = 0
var canUseHorsepower = false
var playerHealth : int = 20
var maxHealth : int = 20

func _ready() -> void:
	hit_box.monitoring = false
	update_health_ui()

func _physics_process(_delta: float) -> void:
	move_and_slide()
	update_animation()
	get_input()

func get_input() -> void:
	# Handle Gallop (E key)
	if Input.is_action_just_pressed("gallop") and not isAttacking:
		hit_box.monitoring = true
		isAttacking = true
		attackCounter += 1
		$AnimatedSprite2D.play("gallop")

	# Handle Horsepower (Q key)
	if Input.is_action_just_pressed("horsepower") and canUseHorsepower:
		hit_box.monitoring = true
		isAttacking = true
		attackCounter = 0
		canUseHorsepower = false
		$AnimatedSprite2D.play("horsepower")

	# Movement input
	if Input.is_action_pressed("D"):
		velocity.x = lerp(velocity.x, speed, acceleration)
		$AnimatedSprite2D.flip_h = false
	if Input.is_action_pressed("A"):
		velocity.x = lerp(velocity.x, -speed, acceleration)
		$AnimatedSprite2D.flip_h = true
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
		pass  # Animation is handled in _on_animated_sprite_2d_animation_finished
	elif velocity.length() > 0:
		$AnimatedSprite2D.play("player_walk")
	else:
		$AnimatedSprite2D.frame = 0  # Idle frame

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "gallop":
		isAttacking = false
		hit_box.monitoring = false
		canUseHorsepower = true  # Enable Horsepower after Gallop finishes
	elif $AnimatedSprite2D.animation == "horsepower":
		isAttacking = false
		hit_box.monitoring = false

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		if canUseHorsepower:
			body.take_damage(2)
			canUseHorsepower = false
		else:
			body.take_damage(1)

func update_health_ui() -> void:
	health_bar.value = playerHealth
	health_bar.max_value = maxHealth
	health_label.text = "Health: %d/%d" % [playerHealth, maxHealth]

func heal(amount: int) -> void:
	playerHealth = maxHealth
	update_health_ui()

func take_damage(amount: int) -> void:
	playerHealth -= amount
	playerHealth = max(playerHealth, 0)
	update_health_ui()

	if playerHealth <= 0:
		player_died()

func player_died() -> void:
	queue_free()
