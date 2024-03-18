extends Area2D

signal water_used(amount)

@export var projectile: PackedScene
@onready var spawn_point: Marker2D = $SpawnPoint
var flow_rate = 1.5


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(_delta):
	var mouse_position = get_global_mouse_position()
	var character_position = global_position
		
	# Determine if the mouse is to the left or right of the character
	if mouse_position.x < character_position.x:
		# Mouse is to left, Flip Sprite
		scale.x = 1
		scale.y = -1
	else:
		# Mouse is to the right, Keep sprite the same homie
		scale.y = 1
		scale.x = 1

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			$water_sound.play()
		
		else:
			$water_sound.stop()

func _physics_process(_delta):
		if Input.is_action_pressed("shoot_water"):
			shoot()
		look_at(get_global_mouse_position())
		
		

func use_water(amount:float):
	print("DEBUG- Use_water - Weapon")
	emit_signal("water_used", amount)
	

func shoot():
	var player = get_parent()
	if player.current_water > 0: # Gotta make sure there is water
		var water = projectile.instantiate()
		water.position = spawn_point.global_position # Ensure the projectile starts at the marker2D
		water.direction = (get_global_mouse_position() - spawn_point.global_position).normalized()
		get_tree().root.add_child(water)
		
		# Emit the signal with the amount of water used per shot
		emit_signal("water_used",flow_rate)
		use_water(flow_rate)
		player.current_water -= flow_rate # Deduct the water used.
		print(flow_rate)
		
	else:
		print("out of water")
		

