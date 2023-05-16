extends KinematicBody2D


export var SPEED : float = 140
onready var sprite : Sprite = $Sprite
var direction = Vector2.LEFT

func set_direction(target_direction : Vector2):
	direction = target_direction
	if direction == Vector2.RIGHT:
		sprite.flip_h = true
	

func _physics_process(dt):
	var collision : KinematicCollision2D = move_and_collide(direction * SPEED * dt)
	if collision:
		_on_collision(collision)

func _on_collision(col : KinematicCollision2D):
	if col.collider.get_collision_layer_bit(4): #player
		col.collider.damage()
	destroy()

func destroy():
	queue_free()
