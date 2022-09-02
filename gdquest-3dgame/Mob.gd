extends RigidBody

export var min_speed = 10.0
export var max_speed = 18.0

signal squashed

var velocity = Vector3.ZERO
onready var navigationAgent : NavigationAgent = $NavigationAgent

func _physics_process(delta):
	var currentPos = global_transform.origin
	var target = navigationAgent.get_next_location()
	velocity = Vector3()

	var normal = $RayCast.get_collision_normal()
	var absNormal = Vector3(abs(normal.x), abs(normal.y), abs(normal.z))
	var invFloorNormal = Vector3(1,1,1) - absNormal

	velocity = ((target - currentPos) * invFloorNormal) * min_speed
	navigationAgent.set_velocity(velocity)
#	

func initialize(start_position, player_position):
	translation = start_position
	navigationAgent.set_target_location(player_position)
	
	print("spawn location ", translation)
	
	print("target location ", player_position)
	
	print("is_target_reachable ", navigationAgent.is_target_reachable())
	print("is_target_reached ", navigationAgent.is_target_reached())
	
	
	look_at(player_position, Vector3.UP)
	rotate_y(rand_range(-PI/4.0, PI/4.0))
	var random_speed = rand_range(min_speed, max_speed)
	
	$AnimationPlayer.playback_speed = random_speed / min_speed

func squash():
	emit_signal("squashed")
	queue_free()

func _on_VisibilityNotifier_screen_exited():
	queue_free()

#extends KinematicBody
#
#export var min_speed = 10.0
#export var max_speed = 18.0
#
#signal squashed
#
#var velocity = Vector3.ZERO
#
#func _physics_process(_delta):
#	move_and_slide(velocity)
#
#func initialize(start_position, player_position):
#	translation = start_position
#	look_at(player_position, Vector3.UP)
#	rotate_y(rand_range(-PI/4.0, PI/4.0))
#
#	var random_speed = rand_range(min_speed, max_speed)
#	velocity = Vector3.FORWARD * random_speed
#	velocity = velocity.rotated(Vector3.UP, rotation.y)
#	$AnimationPlayer.playback_speed = random_speed / min_speed
#
#func squash():
#	emit_signal("squashed")
#	queue_free()
#
#func _on_VisibilityNotifier_screen_exited():
#	queue_free()


func _on_NavigationAgent_navigation_finished():
	var p = get_node("/root/Main/Player")
	if p == null:
		queue_free()
	else:
		look_at(p.global_transform.origin, Vector3.UP)
		rotate_y(rand_range(-PI/4.0, PI/4.0))
		navigationAgent.set_target_location(p.global_transform.origin)

func _on_NavigationAgent_velocity_computed(safe_velocity):
	set_linear_velocity(safe_velocity)

func _on_NavigationAgent_target_reached():
	var p = get_node("/root/Main/Player")
	if p == null:
		queue_free()
	else:
		look_at(p.global_transform.origin, Vector3.UP)
		rotate_y(rand_range(-PI/4.0, PI/4.0))
		navigationAgent.set_target_location(p.global_transform.origin)

