extends CharacterBody3D

@export var SPEED = 5.0
@export var JUMP_VELOCITY = 6
#@export var GravityConstant = 9.81

##instead, try using terminal velocity
@export var Terminal_Velocity = 40


var mouseCaptured := false

@onready var camera: Camera3D = $Head/Camera3D
@onready var head: Node3D = $Head

#@onready var collision_1: Area3D = $Collision1
#@onready var collision_2: Area3D = $Collision2

var yaw = 0.0
var pitch = 0.0

func _ready() -> void:
	pass
	
func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseMotion:
		if not mouseCaptured: return
		# Rotate Body Horizontally
		yaw -= event.relative.x * 0.005
		# Rotate Head Vertically
		pitch -= event.relative.y * 0.005
		pitch = clamp(pitch, -PI/2, PI/2)
		
		rotation.y = yaw
		head.rotation.x = pitch
	
	# Capture cursor on click
	if event.is_action_pressed("mouse_capture"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		mouseCaptured = true
	
	# Release cursor on "Escape"
	if event.is_action_pressed("mouse_release"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		mouseCaptured = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if velocity.y >= -40:
			velocity += get_gravity() * delta

		#velocity.y = -GravityConstant

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
