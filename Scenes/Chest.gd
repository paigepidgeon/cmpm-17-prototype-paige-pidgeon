extends StaticBody2D

var opened := false
var in_range := false

var player : player

signal open

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	pass

func _process(delta: float) -> void:
	if Input.is_action_pressed("Open") && in_range && !opened:
		player.add_money(8)
		opened = true
		open.emit()

func _on_open_radius_body_entered(body: Node2D) -> void:
	if body is player:
		in_range = true

func _on_open_radius_body_exited(body: Node2D) -> void:
	if body is player:
		in_range = false
