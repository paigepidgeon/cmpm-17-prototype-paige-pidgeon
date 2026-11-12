extends CharacterBody2D


var speed = 50
var player_chase = false
var player = null

func _physics_process(delta):
	if player_chase:
			
			position += (player.position - position)/speed
			print("moving")
		
	move_and_slide()
		
		#play animation based on movement 
	if velocity.length() >0:
		$AnimatedSprite2D.play("enemy_hop")
		
		
		
func _on_detection_area_body_entered(body):
	player = body
	player_chase = true
	print ("detected")
	
func _on_detection_area_body_exited(body):
	player = null

	player_chase = false
	print("exited")
