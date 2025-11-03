extends CharacterBody3D
signal hit

@export var speed := 14.0
@export var fall_acceleration := 75.0
@export var jump_impulse := 20.0
@export var bounce_impulse := 16.0

var target_velocity := Vector3.ZERO

func _physics_process(delta):
	var direction := Vector3.ZERO

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
		$Pivot.look_at(global_position + direction, Vector3.UP)

	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse

	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	if not is_on_floor():
		target_velocity.y -= fall_acceleration * delta

	velocity = target_velocity
	move_and_slide()

	for i in range(get_slide_collision_count()):
		var collision := get_slide_collision(i)
		var collider := collision.get_collider()
		if collider and collider.is_in_group("mob"):
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				collider.squash()
				target_velocity.y = bounce_impulse
				break

func _on_mob_detector_body_entered(body: Node3D) -> void:
	die()

func die():
	hit.emit()
	queue_free()
