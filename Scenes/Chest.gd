extends Area2D
@export var health_item_scene: PackedScene
@export var chest_open_texture: Texture2D
@export var chest_closed_texture: Texture2D


signal chest_opened(chest)
signal chest_closed(chest)

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
		
	if health_item_scene == null:
		push_error("health_item_scene is not assigned in the inspector!")
		
	is_opened = true
	
	var health_item = health_item_scene.instantiate()
	health_item.global_position = global_position
	health_item.global_position.y -= 32
	get_parent().add_child(health_item)
	
	health_item.connect("item_collected",_on_item_collected)

	if chest_open_texture:
		sprite.texture = chest_open_texture
	else:
		push_error("chest_open_texture is not assigned in the inspector!")
		sprite.texture = preload("res://assets/chest_open.png")

	emit_signal("chest_opened", self) 
	
func _on_item_collected():
		close_chest()
		
func close_chest():
	if not is_opened:
		return
		
	is_opened = false 
		
	if chest_closed_texture:
		sprite.texture = chest_closed_texture
	else:
		push_error("chest_closed_texture is not assigned in the inspector")
		sprite.texture = preload("res://assets/chest_closed.png")

	emit_signal("chest_closed",self)
