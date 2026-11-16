extends Area2D
class_name HealthItem

@export var health_to_give: int = 20

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready():
	pass

func _on_body_entered(body):
	if body.name == "player":
		if body.has_method("get_health") and body.has_method("set_health"):
			var current_health = body.get_health()
			var max_health = body.maxHealth if body.has_method("maxHealth") else health_to_give

			if current_health < max_health:
				body.set_health(max_health)
				queue_free()
		else:
			print("Player script not found or missing health methods")

func _on_visibility_notifier_2d_screen_exited():
	queue_free()
