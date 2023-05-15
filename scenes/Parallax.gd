extends ParallaxBackground

export var yspeed = 32
onready var layer1 = $ParallaxLayer

func _process(delta):
	layer1.motion_offset += delta*Vector2(0, yspeed)
