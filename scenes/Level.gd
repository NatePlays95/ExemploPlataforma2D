extends Node2D


export var REQUIRED_FRUIT : int = 20
onready var obtained_fruit = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_collectable_collected():
	obtained_fruit += 1
	update_victory()

func update_victory():
	if obtained_fruit >= REQUIRED_FRUIT:
# warning-ignore:return_value_discarded
		var tween = get_tree().create_tween()
		tween.tween_interval(2.0)
		tween.tween_callback(get_tree(), "change_scene", ["res://scenes/End.tscn"])
