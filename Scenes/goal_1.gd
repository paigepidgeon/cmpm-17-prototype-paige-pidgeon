extends Area2D
@onready var sfx_levelup = $sfx_jump


func _on_body_entered(body: Node2D) -> void:
	if body is player:
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/level_2.tscn")
	
