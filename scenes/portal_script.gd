extends Node3D
class_name Portal

##this refers to the other in the pair
@export var otherPortal: Portal
@onready var camera_3d: Camera3D = $Camera3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if otherPortal:
		#var playerCam := get_viewport().get_camera_3d()
		var playerHead: Node3D = get_parent().player.head
		var playerCam : Camera3D = get_parent().player.camera
		var otherCam := otherPortal.camera_3d
		
		var relPos = playerCam.global_position - global_position
		otherCam.position = transform.basis * relPos
		otherCam.rotation = playerHead.rotation
	
	#if otherPortal:
		#var pos := otherPortal.camera_3d.global_position
		#print(otherPortal.name, pos)
	#_getPlayerCamera()
## need to do 2 things: calc distance from this portal to player camera
## tell the other portal this distance so it can change camera position

func _getPlayerCamera() -> void:
	var cam = get_viewport().get_camera_3d()
	### use these to control the other camera
	var camPosition = cam.global_position
	var camRotation = cam.global_rotation
	otherPortal.global_position = self.global_position - camPosition
	return


func _on_body_entered(player: Node3D) -> void:	
	# teleport player to other portal
	#any affect to player position breaks game
	#if otherPortal:
		#player.global_position = otherPortal.global_position
		#print("TELEPORT!")
		
	# check front or back of collider
	var dif = player.global_position - self.global_position

	##keep player y constant
	if otherPortal:
		player.global_position = otherPortal.global_position + dif + Vector3(0,-5,0)
		return
		#if player.global_position.z > self.global_position.z:
			#player.global_position = otherPortal.global_position - dif
			#return
		#if player.global_position.z < self.global_position.z:
			#player.global_position = otherPortal.global_position - dif
			#return
		


#func _on_collision_1_body_exited(player: Node3D) -> void:
	#player.global_position = otherPortal.global_position
	#pass # Replace with function body.
