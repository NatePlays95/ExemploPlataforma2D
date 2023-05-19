extends KinematicBody2D

export var RUN_SPEED : float = 50
export var CAN_WALK : bool = true

var bullet_scene = load("res://scenes/characters/EnemyStumpBullet.tscn")

enum STATES {IDLE, RUN, SHOOT, HIT}
var current_state = STATES.IDLE

var idle_timer : float = 1.6
var velocity : Vector2 = Vector2.ZERO
var has_line_of_sight = false

onready var animsprite = $AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _destroy():
	queue_free()


func _physics_process(dt):
	velocity = Vector2.ZERO
	
	if current_state == STATES.HIT: return
	
	look_for_players()
	if current_state == STATES.SHOOT:
		animsprite.play("shoot")
		#if frame = x spawn bullet
	else:
		if has_line_of_sight:
			current_state = STATES.SHOOT
	
	if current_state == STATES.RUN:
		animsprite.play("run")
		
		if not check_if_can_walk():
			current_state = STATES.IDLE
			idle_timer = 1.6 #idle wait time
		else:
			velocity = Vector2.LEFT * RUN_SPEED
			if animsprite.flip_h:
				velocity.x *= -1
			move_and_slide(velocity, Vector2.UP)
		
	elif current_state == STATES.IDLE:
		animsprite.play("idle")
		
		idle_timer -= dt
		if idle_timer <= 0:
			current_state = STATES.RUN
			if not check_if_can_walk(): #flip if there's wall or there's no floor
				animsprite.flip_h = not animsprite.flip_h



func look_for_players():
	var los_raycast = $LineOfSight
	los_raycast.cast_to.x = 512 if animsprite.flip_h else -512
	los_raycast.force_raycast_update()
	has_line_of_sight = los_raycast.is_colliding()



func check_if_can_walk() -> bool:
	if not CAN_WALK: return false
	
	var wallchecks
	var floorchecks
	
	if not animsprite.flip_h:
		wallchecks = $WallDetectorsLeft.get_children()
		floorchecks = $FloorDetectorsLeft.get_children()
	else:
		wallchecks = $WallDetectorsRight.get_children()
		floorchecks = $FloorDetectorsRight.get_children()
	
	for r in wallchecks:
		var raycast : RayCast2D = r
		raycast.force_raycast_update()
		if raycast.is_colliding():
			return false
	
	for r in floorchecks:
		var raycast : RayCast2D = r
		raycast.force_raycast_update()
		if not raycast.is_colliding():
			return false
	
	return true



func shoot():
	var bullet_instance = bullet_scene.instance()
	
	get_parent().add_child(bullet_instance)
	
	if animsprite.flip_h:
		bullet_instance.global_position = $PositionBulletR.global_position
		bullet_instance.set_direction(Vector2.RIGHT)
	else:
		bullet_instance.global_position = $PositionBulletL.global_position
		bullet_instance.set_direction(Vector2.LEFT)
	
	
	



func _on_bounced_on(_body : PhysicsBody2D):
	current_state = STATES.HIT
	animsprite.play("hit")


func _on_AnimatedSprite_animation_finished():
	if animsprite.animation == "hit":
		_destroy()
	elif animsprite.animation == "shoot":
		current_state = STATES.RUN


func _on_AnimatedSprite_frame_changed():
	if animsprite.animation == "shoot" and animsprite.frame == 7:
		shoot()
