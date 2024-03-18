extends Area2D

signal resupply_trigger



func _on_body_entered(body):
	if body.is_in_group("player"): 
		$AnimatedSprite2D.play()
		$hydrant_sound.play()
		print("resupplied signal sent ")
		emit_signal("resupply_trigger")

	


func _on_body_exited(body):
	if body.is_in_group("player"):
		$AnimatedSprite2D.stop()
		$hydrant_sound.stop()
