extends AnimatedSprite

signal collected

# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:return_value_discarded
	connect("collected", get_tree().current_scene, "_on_collectable_collected")
	play()
	


func _on_Area2D_body_entered(_body):
	call_deferred("disable_area")
	emit_signal("collected")
	play("collected")

func disable_area():
	$Area2D/CollisionShape2D.disabled = true

func _on_animation_finished():
	if animation == "collected":
		queue_free()
