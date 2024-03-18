extends Area2D

signal score

var health = 50 # health value of fire

func _ready():
	connect("area_entered",_on_area_entered)

func _physics_process(_delta):
	$Fire_Animation.play()


func decrease_health():
	health -= 1 
	print("DEBUG-Decrease Health Function")
	print(health)
	if health <= 0:
		print(score)
		queue_free()
		emit_signal("score")
		


func _on_area_entered(area):
	if area.is_in_group("water"):
		print("DEBUG-Area is in group water ")
		decrease_health()

