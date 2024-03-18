extends CanvasLayer

signal start_game

# Starting Values of water
var max_water: float = 1500
var current_water: float = 1500

@onready var water_bar: ProgressBar = $ProgressBar

func _ready():
	water_bar.max_value = max_water
	water_bar.value = current_water
	

	
func _on_player_water_level_changed(new_water_level):
	current_water = new_water_level
	print("Water Level changed to:", new_water_level)
	update_water_bar()

	
func update_water_bar():
	water_bar.value = current_water

func show_message(text):
	$StartMessage.text = text
	$StartMessage.show()
	$MessageTimer.start()

func update_score(score):
	$Score.text = str(score)

func show_game_over():
	show_message("The city is in ashes, hopefully you tried your best.")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout
	
	$StartMessage.text = "The city is on fire.."
	$StartMessage.show()
	
	# Make a oneshot timer
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func show_game_over_win():
	show_message("You survived.. take a rest.. you deserve it.")
	# wait until the message time has counted down.
	await $MessageTimer.timeout
	
	show_message("Restart?")
	await get_tree().create_timer(30.0).timeout

	$StartButton.show()

func _on_start_button_pressed():
	$StartButton.hide()
	emit_signal("start_game")

func _on_message_timer_timeout():
	$StartMessage.hide()



