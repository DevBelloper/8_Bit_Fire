extends Node

@export var fire_scene: PackedScene

var score
var last_fire_position = Vector2() # Place Holder
var spawn_area_rect = Rect2(Vector2(1737, -248), Vector2(1927, 75)) # Spawn Area Refrence Rectangle 
var fire_amount = 10 # Amount of fire to spawn 
var current_wave = 0 # Enemy wave
var initial_fire_timeout = 3 # Seconds between fires for the first wave
var fire_timeout = initial_fire_timeout
var timeout_decrease = 0.5 # How much to decrease the timeout each wave. 
var max_waves = 5 # Defines the number of waves


func _ready(): 
	new_game()
	var weapon = $Player/Weapon

	weapon.connect("water_used", _on_water_used)

func _on_water_used(_amount):
	print("DEBUG- water used MAIN SCRIPT")
	

func new_game():
	score = 0 
	$StartTimer.start()
	get_tree().call_group("fire", "queue_free")
	$HUD.update_score(score)
	$HUD.show_message("The forest is on fire..")
	
func game_over():
	$FireTimer.stop()
	$HUD.show_game_over()
	
func game_over_win():
	$FireTimer.stop()
	$HUD.show_game_over_win()
	
func _on_start_timer_timeout():
	$FireTimer.start()
	
func _on_fire_timer_timeout():
	# Cehck too see if there is a lmit for spawning fires
	if fire_amount > 0 :
		spawn_fire()
		fire_amount -= 1
	else:
		check_for_remaining_fires()
	
func check_for_remaining_fires():
	var fire_instances = get_tree().get_nodes_in_group("fire")
	if len(fire_instances) == 0 and fire_amount <= 0:
		prepare_next_wave()
		
func prepare_next_wave():
	if current_wave >= max_waves:
		game_over_win() # Player wins if he survives whatever the heck is happening
		return
		
	current_wave += 1 	# Increment Wave Count
	$HUD.show_message( "Wave " + str(current_wave) + " completed. The forest is still burning..")
	
	# Implement a delay or some visual feedback that a new wave is starting
	await get_tree().create_timer(2.0).timeout # Waits two seconds before starting the next wave.
	
	fire_amount = 10 + current_wave * 5 # Difficulty scalling here boss
	fire_timeout = max(fire_timeout - timeout_decrease, 0.5) # Timer doesn't become negative or to low
	$FireTimer.wait_time = fire_timeout # Apply new timeout to the timer 
	$FireTimer.start() # Restart timer for next wave
	$HUD.show_message("Wave " + str(current_wave))
	
func spawn_fire():
	# Creating a new instance of the fire
	var fire = fire_scene.instantiate()
	fire.add_to_group("fire")
	
	# Dynamically connect fires as the spawn
	fire.connect("score",increase_score)
	
	# Set limit to fire spawning
	var bottom_right = spawn_area_rect.position + spawn_area_rect.size
	
	# Calculate a New position within the rectangle, from bottom right to top left.
	var x = bottom_right.x - randi() % int(spawn_area_rect.size.x)
	var y = bottom_right.y - randi() % int(spawn_area_rect.size.y)
	
	# Make sure the spawn stays within the Rect2D
	var spawn_position = Vector2(x,y).clamp(spawn_area_rect.position, bottom_right)
	
	fire.global_position = spawn_position
	add_child(fire)
	
func increase_score():
	score += 1
	check_for_remaining_fires()
	print("DEBUG-Increase score Function")
	$HUD.update_score(score)
	

	
