extends CharacterBody2D

signal water_used(amount) # Signal to emit when water is used
signal water_level_changed(current_water) # Signal to emit when water level changes

@export var speed = 400
# Starting Values of water (Fire engines carry their own water, Water tank sizes range from 500 - 1500 Gallons.)
var max_water = 15000
var current_water = max_water
var is_idle = true # Keep track of idle state for player movement

func _ready():
	var weapon = $Weapon
	weapon.connect("water_used",_on_weapon_water_used)
	var resupply_area = get_node("/root/Main/Resupply") # Adjust the path
	resupply_area.connect("resupply_trigger",_on_Resupply_trigger)
	
func _on_Resupply_trigger():
	print("Signal recieved loud and clear for resupply")
	current_water = max_water
	emit_signal("water_level_changed", current_water)
	
	
	
func _on_weapon_water_used(amount):
	current_water -= amount
	current_water = max(current_water, 0)
	emit_signal("water_level_changed", current_water)
	
func get_input():
	velocity.x = 0
	var right = Input.is_action_pressed("move_right")
	var left = Input.is_action_pressed("move_left")

	if right:
		velocity.x += speed
		$Weapon.position = Vector2(12, -36)

	if left:
		velocity.x -= speed
		$Weapon.position = Vector2(-25, -36)
		

func _physics_process(_delta):
	velocity = Vector2.ZERO 
	
	get_input()

	if velocity.length() == 0:
		if not is_idle:
			$Drive.stop() # Stop driving sound if its playing 
			$Idle.play() # Play idle sound
			$Player_Animation.play("Idle")
			is_idle = true #  Set the flag for idle 
	else:
		if is_idle:
			$Idle.stop() # Stop idle
			$Drive.play() # Play driving sound
			$Player_Animation.play ("Drive")
			$Player_Animation.flip_h = velocity.x > 0
			is_idle = false # set the flag for idle to indicate not idle
	
	move_and_slide()

func use_water(amount: float):
	current_water = max(current_water - amount, 0) # Safeguard against negative
	emit_signal("water_level_changed",current_water) # Notify the HUD

