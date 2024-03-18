extends Area2D

class_name Projectile
@export var lifetime_seconds: float = 2.0

var direction = Vector2(1.0,0.0)
var speed: float = 600

func _process(delta):
	position = position + speed * direction * delta

func _ready():
	#Start time for that will despawn the projectile after its lifetime EXPIRES
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = lifetime_seconds
	timer.one_shot = true
	timer.start()
	timer.connect("timeout", _on_Timer_timeout)
	
	connect("area_entered", _on_Water_area_entered)
	
func _on_Timer_timeout():
	queue_free() # Automatcally despawns projectiles when the timer EXPIRES
	
func _on_Water_area_entered(area):
	if area.is_in_group("fire"):
		queue_free()
	
	


