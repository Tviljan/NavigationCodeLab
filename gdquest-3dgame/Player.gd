extends KinematicBody

signal hit

export var speed = 14.0
export var jump_impulse = 20.0
export var fall_acceleration = 75.0
export var bounce_impulse = 16.0

var velocity = Vector3.ZERO

func _ready():
	#$Pivot/Monster/AnimationPlayer.set_autoplay("RUN")
	pass
func _physics_process(delta):
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
		
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	
	if Input.is_action_pressed("move_back"):
		direction.z += 1
		
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.look_at(translation + direction, Vector3.UP)
		$Pivot/Monster/AnimationPlayer.play("RUN")	
	else:
		$Pivot/Monster/AnimationPlayer.play("IDLE")	
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	if is_on_floor() and Input.is_action_pressed("jump"):
		velocity.y += jump_impulse
	
	velocity.y -= fall_acceleration * delta
	velocity = move_and_slide(velocity, Vector3.UP)

	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.get_class() == "RigidBody": #.collider.is_in_group("mobs"):
			var mob = collision.collider
			var f = Vector3.UP.dot(collision.normal)
			if f > 0.1:
				mob.squash()
				velocity.y = bounce_impulse
			else:
				print("F", f)
	$Pivot.rotation.x = PI / 6.0 * velocity.y / jump_impulse		

func die():
	emit_signal("hit")
	queue_free()
	
func _on_MobDetector_body_entered(body):
	die()
