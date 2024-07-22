extends Node

@export var fire_scene: PackedScene

var score = 0
var last_fire_position = Vector2() # Place Holder
var spawn_area_rect = Rect2(Vector2(1737, -248), Vector2(1927, 75)) # Spawn Area Refrence Rectangle 
var fire_amount = 1 # Amount of fire to spawn 
var current_wave = 0 # Enemy wave
var initial_fire_timeout = 3 # Seconds between fires for the first wave
var fire_timeout = initial_fire_timeout
var timeout_decrease = 0.5 # How much to decrease the timeout each wave. 
var max_waves = 5 # Defines the number of waves
var wave_wait = 1.0 # How long in-between waves

func new_game():
	score = 0 # Set score to zero
	$StartTimer.start() 
	get_tree().call_group("fire", "queue_free") # Removes all fires when game is started
	# Begin calls to HUD 
	$HUD.update_score(score)
	$HUD.show_message("The forest is on FIRE!!!")
	$StartTimer.connect("timeout", _on_start_timer_timeout) # Connect the timeout signal to the function
	$FireTimer.connect("timeout", _on_fire_timer_timeout) # Connect the timeout signal to the function
	
func game_over():
	$FireTimer.stop()
	$HUD.show_game_over()

func game_over_win():
	$FireTimer.stop()
	$HUD.show_game_over_win()
	
func _on_start_timer_timeout():
	$FireTimer.start()
	check_for_remaining_fires()
	
func _on_fire_timer_timeout():
	# Check to see if there is a limit for spawning fires
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
		game_over_win() # Player wins if he survives the waves
		return
	$HUD.show_message("Wave" + str(current_wave))
	$HUD.show_message( "The fire has taken a break..")
	
	$WaveTimer.wait_time = wave_wait
	$WaveTimer.start() # Start timer for next wave
	$WaveTimer.connect("timeout", _on_wave_timer_timeout) # Connect the timeout signal to the function
	
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
	#print("DEBUG-Increase score Function")
	$HUD.update_score(score)
	
func _on_wave_timer_timeout():
	print("on wave timer")
	current_wave += 1 	# Increment Wave Count
	$HUD.show_message("Wave " + str(current_wave))
	
	fire_amount = 10 + current_wave * 5 # Difficulty scaling here boss
	fire_timeout = max(fire_timeout - timeout_decrease, 0.5) # Timer safeguard so timer doesn't become negative or too low
	$FireTimer.wait_time = fire_timeout # Apply new timeout to the timer 
	$FireTimer.start() # Restart timer for next wave
	
	if current_wave >= max_waves:
		game_over_win() # Player wins if he survives the waves
	
