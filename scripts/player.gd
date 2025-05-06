extends CharacterBody3D

@onready var head: Node3D = $head
@onready var camera_3d: Camera3D = $head/Camera3D
@onready var raycast: RayCast3D = $head/Camera3D/RayCast3D

var currentSpeed = 5.0
var look_rotation = Vector2()
const WALK_SPEED = 5.0
const SPRINT_SPEED = 8.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENS = 0.003

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

#func _input(event):
#	if event is InputEventMouseMotion:
#		rotation.y += (-event.relative.x * MOUSE_SENS)
#		rotation.x += (-event.relative.y * MOUSE_SENS)
#		rotation.x = clamp(rotation.x, -90, 90)
#	
#	if event.is_action_pressed("ui_cancel"):
#		get_tree().quit()

func _input(event):
	if event is InputEventMouseMotion:
		look_rotation.x -= event.relative.x * MOUSE_SENS
		look_rotation.y -= event.relative.y * MOUSE_SENS
		look_rotation.y = clamp(look_rotation.y, -1.5, 1.5)  # Prevent flipping

		rotation.y = look_rotation.x
		head.rotation.x = look_rotation.y

	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()


func _physics_process(delta: float) -> void:
	
	# raycast
	if Input.is_action_just_pressed("interact"):
		#print("interact")
		if raycast.is_colliding():
			#print("raycast hit")
			var hit = raycast.get_collider()
			var door = hit.get_parent()
			if door and door.has_method("toggle_door"):
				#print("raycast hit door")
				door.toggle_door()
	
	if Input.is_action_pressed("sprint"):
		currentSpeed = SPRINT_SPEED
	else:
		currentSpeed = WALK_SPEED
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * currentSpeed
		velocity.z = direction.z * currentSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, currentSpeed)
		velocity.z = move_toward(velocity.z, 0, currentSpeed)

	move_and_slide()
