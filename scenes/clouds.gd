extends ParallaxLayer



var Cloud_speed = -0.75

func _process(_delta):
	self.motion_offset.x += Cloud_speed
