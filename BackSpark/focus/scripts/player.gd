extends CharacterBody3D

#This is all speed based stuff
const  SPRINT_SPEED = 10
var speed = 10
var sprintadd = 1
const JUMP_VELOCITY = 5
const SENSITIVITY = 0.004
const  SNEAKSPEED = 3.0

@export var mouselock = true
signal toggle_inventory
#inventory scripting
@export var inventory_data: InventoryData


var fovtoggle = 1
#coyotetime ie "delayed keypress
var walljump = true
var floorjump = false

@onready var coyotetime = $coyotetime

#appearance variables
var bob_amp = 0.08
var t_bob = 0.0
var bob_freq = 2.4
var sparks = true
#fov variables
const BASE_FOV = 75.0
const FOV_CHANGE = 2.25

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 10

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var interactray: RayCast3D = $Head/Camera3D/interactray

#im only using the _process function to troubleshoot
func _process(_delta):
	pass  

#this makes the mouse move the camera, the clamp and deg_to_rad lock the camera in place
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-85), deg_to_rad(85))
		
	if Input.is_action_just_pressed("Tab"):
		toggle_inventory.emit()
func _physics_process(delta):


	# Add the gravity.
#this is gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	if is_on_wall_only():
		walljump = true

	if is_on_floor():
		floorjump = true

	if is_on_floor() or is_on_wall():
		coyotetime.wait_time = 0.2
		coyotetime.start()


	# Handle Jump.
	if Input.is_action_just_pressed("space"):
		if floorjump == true:
			velocity.y = JUMP_VELOCITY
		elif walljump == true:
			velocity.y = JUMP_VELOCITY * 1.5
		else:
			pass

	if Input.is_action_pressed("control"):
		if is_on_wall() == true:
			velocity.y = 0
#headbobtoggle
	if Autoload.headbob == true:
		bob_amp = 0.08
		bob_freq = 2.4
	else:
		t_bob = 0
		bob_freq = 0



	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("A", "D", "W", "S")
	var direction = (head.transform.basis * transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)

	# Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)

	# FOV

	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 1.0)


	move_and_slide()

func _headbob(time) -> Vector3:
		var pos = Vector3.ZERO
		pos.y = sin(time * bob_freq) * bob_amp
		pos.x = cos(time * bob_freq / 2) * bob_amp
		return pos

func mousemodecap():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func mousemodevis():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_coyotetime_timeout():
	walljump = false
	floorjump = false



	
