extends TextureButton

var was_pressed = false

func _process(dt):
	if pressed and not was_pressed:
		was_pressed = true
		rect_position.y += 8
	elif was_pressed:
		was_pressed = false
		rect_position.y -= 8


func _on_pressed():
	get_tree().reload_current_scene()
