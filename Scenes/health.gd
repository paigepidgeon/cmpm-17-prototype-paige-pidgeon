extends Sprite2D

var player_reference : player = null

func _ready() -> void:
	player_reference = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
	scale.x = move_toward(scale.x, player_reference.playerHealth / player_reference.maxHealth, delta)
