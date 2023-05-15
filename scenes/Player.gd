extends KinematicBody2D


#export var RUN_FRICTION : float = 10
export var RUN_ACCEL : float = 1000
export var RUN_DECCEL : float = 600
export var RUN_MAX_SPEED : float = 160

export var JUMP_SPEED : float = 450
export var JUMP_RELEASE_SPEED : float = 150

export var GRAVITY : float = 1500

var velocity : Vector2 = Vector2.ZERO
var input_vector : Vector2 = Vector2.ZERO
var grounded : bool = false

onready var animsprite : AnimatedSprite = $AnimatedSprite

func _ready():
	pass


func _process(dt):
	_process_input()
	_process_animation()


func _process_input():
	input_vector = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	)


func _process_animation():
	if velocity.x > 0:
		animsprite.flip_h = false
	if velocity.x < 0:
		animsprite.flip_h = true
	
	#guardrail checks
	
	if not grounded:
		if velocity.y < 0:
			animsprite.play("jump")
		else:
			animsprite.play("fall")
		return
	
	if velocity.x != 0:
		animsprite.play("run")
		return
		
	animsprite.play("idle")
	return


func _physics_process(dt):
	_test_for_ground(dt)
	_apply_movement(dt)



func _test_for_ground(dt):
	#grounded = is_on_floor()
	#return
	
	#TODO: scrap this
	grounded = false
	if velocity.y < 0: return
	
	for raycast in $GroundRaycasts.get_children():
		#var raycast : RayCast2D = r
		raycast.cast_to.y = max(1, dt*velocity.y) + 1
		raycast.force_raycast_update()
	for raycast in $GroundRaycasts.get_children():
		if raycast.is_colliding():
			grounded = true
			break



func _apply_movement(dt):
	
	#horizontal movement
	#velocity.x -= velocity.x*dt * RUN_FRICTION
	if input_vector.x != 0:
		velocity.x += dt*RUN_ACCEL * input_vector.x
	else:
		velocity.x -= min(dt*RUN_DECCEL, abs(velocity.x)) * sign(velocity.x)
	velocity.x = clamp(velocity.x, -RUN_MAX_SPEED, RUN_MAX_SPEED)
	
	#vertical movement
	if not grounded:
		velocity.y += GRAVITY*dt
	
	#jump
	if grounded and Input.is_action_just_pressed("ui_up"):
			velocity.y = -JUMP_SPEED
			print_debug("jump")
	#jump release
	if not grounded:
		if Input.is_action_just_released("ui_up") and velocity.y < -JUMP_RELEASE_SPEED:
			velocity.y = -JUMP_RELEASE_SPEED
	
	#apply
	move_and_slide(velocity, Vector2.UP)
	if is_on_floor():
		velocity.y = 0



