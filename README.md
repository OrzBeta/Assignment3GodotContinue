# Getting into Godot: Exercise 5
Andrew Gleeson : RMIT Game Design

CREDITS
[Kenney - Skybox Textures](https://kenney.nl/assets/skyboxes)

# EXERCISE
In this exercise, we are implementing a **simple first-person character controller**
from scratch, as well as a basic, lit scene for them to run around in.

This template includes some extra assets to experiment with the different
3D features once the main tasks are complete (see EXTRAS)

## 1. Creating the Level Scene
	[ ] Create a new 3D Scene. Rename the root node to `Main` and save it as `main.tscn`.
	[ ] In the 3D toolbar, adjust sun/environment settings (3 dots), then add both Sun
		and Environment to the scene (buttons `Add Sun/Environment to Scene`).
		
		Feel free to adjust these settings to get familiar with them.
		The `Environment` resorce contains a lot of rendering settings.
		Some places to look:
			Sky: `WorldEnvironment > Environment > [Sky] > Sky > Sky Material`
			Sun/DirectionalLight3D: Use the editor gizmo to rotate its direction.
		
			
	[ ] There is a premade 'level' scene built with Godot's CSG nodes.
		Create an instance of `level.tscn` into the main scene.

## 2. Creating the Player Scene
	[ ] Create a `CharacterBody3D` node. Rename to `Player`, right+click node, "Save Branch as Scene": `player.tscn`.
	[ ] Add the following child nodes to our Player:
		[ ] `CollisionShape3D`
			Shape: New `CapsuleMesh`
			
		[ ] `MeshInstance3D`
			Shape: New `CapsuleShape3D`
			
		[ ] `Node3D`: rename to "Head"
			[ ] `Camera3D` (child of Head)
			
	[ ] On the player's root node, attach a Script, `player.gd`. Use the template CharacterBody3D script.
	[ ] We can already add code to handle rotating our player. Add this before `_physics_process()`
	```
	@onready var head: Node3D = $Head

	func _input(event: InputEvent) -> void:
		# Rotate Head
		if event is InputEventMouseMotion:
			# Body rotates left/right (yaw)
			rotation.y -= event.screen_relative.x * 0.005
			# Head rotates up/down (pitch)
			head.rotation.x -= event.screen_relative.y * 0.005
			# Stop head rotating too far (otherwise upside down)
			head.rotation.x = clamp(head.rotation.x, -PI/2, PI/2)
			
		# Capture mouse
		if event.is_action_pressed("mouse_capture"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			
		# Release mouse
		if event.is_action_pressed("mouse_release"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	```

	We will need to create some input actions for WASD controls, as well as some helper actions
	for capturing/releasing the mouse cursor.

	[ ] Project Settings - Input Map - "Add New Action", and add bindings to the following:
		- move_forward   : Key W
		- move_left      : Key A
		- move_backward  : Key S
		- move_right     : Key D
		- mouse_capture  : Left Mouse Button
		- mouse_release  : Escape
		
	[ ] Back in our `player.gd` script, we can update the template to use our new Input Actions.
		In _physics_process(), update the line that creates an input vector (replace the action names):
		```
		var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		```
		to
		```
		var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
		```

	Test your game to see if your character controller is working correctly.
	Notice that we are always working 'forward' based on our camera's direction, rather than in world-space.
	It is all thanks to this line (provided by the template):
	```
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	```
	We turn our `input_dir` (a `Vector2`) into a `Vector3` along the X and Z axis (ignoring Y)
	```
	direction = Basis * Vector3
	```
	Multiplying a `Basis` with a `Vector3` returns the right-side `Vector3` multiplied by the `Basis`.
	Since we are rotating our body and head separately (in `_input()`), we get our **yaw** rotation from
	the body and rotate our input direction around it.

	## Complete!
	
	That's it for this exercise!
	
# EXTRAS

## Adding Sprite3Ds, Label3Ds

Godot includes really useful Sprite3D/Label3D nodes to place 2D elements in a 3D scene.
Both include flags for "billboarding", allowing them to always face the current camera.

## Adding Area3Ds

Area3Ds work much the same as Area2Ds. We can use them to detect when actors (like the player) enter
their regions.

The workflow is the same: Add an `Area3D`, a child `CollisionShape3D`, then connect `body_entered/exited`
signals to some code. You can attach a script to the Area3D directly, or elsewhere, whatever makes sense.

## Replace the Sky with a Texture

The default skybox material is a `ProceduralSkyMaterial`, defined as a gradient for the sky & ground.
We can replace this with a `PanoramaSkyMaterial`, and use a `skybox` texture instead.
Use the arrow dropdown to change the sky material, and under `Panorama`, then select "Quick Load" and
choose one of the included skybox textures.

# Editing the Level

The included level is a simple layout built using Godot's CSG nodes, used for "greyboxing" levels.
We will go into more detail next exercise, but you can experiment by adding new CSG nodes.

The level geometry uses a "World Triplanar" material, which aligns texture coordinates to the world
position.
