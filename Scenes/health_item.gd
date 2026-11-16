extends RigidBody2D

@export var heal_amount : int = 20 

@export var rigidbody2D : float = 3.0 

@onready var sprite: Sprite2D = $Sprite2D
@onready var pickup_area : Area2D = $pickup_area


func _ready() -> void:
	set_gravity_scale(gravity_scale)
	linear_damp = 0.3
	angular_damp = 0.5
	
	var direction = Vector2(randf_range(-0.5, 0.5), -1.0).normalized()

	
	apply_torque_impulse(randf_range(-10.0, 10.0) * 200)

func _on_pickup_area_body_entered(body):
	if body.naame == "player" and body.has_method("heal"):
		
		body.heal(body.maxHealth)
		queue_free() 
