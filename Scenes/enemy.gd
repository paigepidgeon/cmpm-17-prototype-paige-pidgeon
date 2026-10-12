extends CharacterBody2D

var speed = 35
var player_chase = false
var player = null

func _physics_process(delta):
	if player:
			# Cslculate direction to the player
			var direction = (player.position - position).normalized()
		
		#move towards the playervelocity = direction * speed
	move_and_slide()
		
		#play animation based on movement 
	if velocity.length() >0:
		$animatedSprite2D.play("run")
		
		
func _on_detection_area_body_entered(body):
	player = body
	player_chase = true
	
func _on_detection_area_body_exited(body):
	player = null
	player_chase = false
