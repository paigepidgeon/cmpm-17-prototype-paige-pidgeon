extends CharacterBody2D
class_name player


@export var speed : float = 130
@export var acceleration : float = 0.05
@export var deceleration : float = 0.05
@onready var hit_box: Area2D = $hitbox


var isAttacking = false
var attackCounter = 0 
var canUseHorsepower = false #number of horsepower attacks availible (idk)
var playerHealth : int = 20


func _physics_process(_delta: float) -> void:
	get_input()
	
func get_input() -> void:
	if Input.is_action_just_pressed("gallop") and not isAttacking:
		hit_box.monitoring = true
		isAttacking = true
		attackCounter += 1 

	if attackCounter >= 2:
		canUseHorsepower = true
		
	if Input.is_action_just_pressed("gallop") and canUseHorsepower:
		# Horsepower attacks (double the damage somewhere here) note to self?
		hit_box.monitoring = true
		isAttacking = true
		attackCounter = 0
		canUseHorsepower= false
		
	
	if Input.is_action_pressed("D"):
		velocity.x = lerp(velocity.x, speed, acceleration)
		$AnimatedSprite2D.flip_h = false
	if Input.is_action_pressed("A"):
		velocity.x = lerp(velocity.x, -speed, acceleration)
		$AnimatedSprite2D.flip_h = true
	else: 
		velocity.x = lerp(velocity.x, 0.0 , deceleration)
	if Input.is_action_pressed("S"):
		velocity.y = lerp(velocity.y, speed , acceleration)
	elif Input.is_action_pressed("W"):
		velocity.y = lerp(velocity.y, -speed , acceleration)
	else:
		velocity.y = lerp(velocity.y, 0.0, deceleration)
	move_and_slide()
	
	if velocity.length() >0:
		$AnimatedSprite2D.play("player_walk")
		
func _ready() -> void:
	hit_box.monitoring = false
	
func _set_animation ():
	if isAttacking:
		$AnimatedSprite2D.play("gallop")

	elif velocity.x >0:
		pass

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "gallop":
		isAttacking = false
		hit_box.monitoring = false

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		
		if canUseHorsepower:
			body.take_damage(2)
	else:
			body.take_damage(1)
			pass
