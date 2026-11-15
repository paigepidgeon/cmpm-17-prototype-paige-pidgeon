extends Area2D
@export var health_item_scene: PackedScene

signal chest_opened(chest)

@onready var sprite: Sprite2D = $Sprite2D
@onready var is_opened: bool = false

func _ready():
	pass

func _on_interact_area_body_entered(body):
		if body.name == "Player" and not is_opened:
			open_chest()

func open_chest():
	if is_opened:
		return
		
	is_opened = true
	
	var health_item = health_item_scene.instantiate()
	health_item.global_position = global_position
	health_item.global_position.y -= 32
	get_parent().add_child(health_item)

	sprite.texture = preload("res://assets/chest_open.png")
	emit_signal("chest_opened", self) 
