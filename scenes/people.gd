extends Area2D

signal score

var health = 50 # health value of people

func _ready():
	connect("area_entered",_on_area_entered)

func _physics_process(_delta):
	#$People_Animation.play()
	pass
	

func decrease_health():
	health -= 1 
	print("DEBUG-Decrease People Health Function")
	print(health)
	if health <= 0:
		print(score)
		queue_free()
		emit_signal("score")
		


func _on_area_entered(area):
	if area.is_in_group("people"):
		print("DEBUG-Area is in group people ")
		decrease_health()

