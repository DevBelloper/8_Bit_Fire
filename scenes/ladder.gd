extends Area2D

class_name Ladder
@export var lifetime_seconds: float = 2.0

var direction = Vector2(1.0,0.0)
var speed: float = 600

func _process(delta):
	position = position + speed * direction * delta


func _ready():
	#Start time for that will despawn the projectile after its lifetime EXPIRES
	
	connect("area_entered", _on_Ladder_area_entered)
	
func _on_Timer_timeout():
	pass
		
func _on_Ladder_area_entered(area):
	if area.is_in_group("people"):
		queue_free()
	
	


