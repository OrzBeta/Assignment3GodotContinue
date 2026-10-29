extends Area3D

func _on_body_entered(body: Node3D) -> void:
	print("PLAYER ENTERED: %s" % body)

func _on_body_exited(body: Node3D) -> void:
	print("PLAYER LEFT: %s" % body)
