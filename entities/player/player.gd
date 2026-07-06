extends CharacterBody2D

func _process(delta: float) -> void:
	var movement_vector = Input.get_vector("left", "right", "up", "down")
	velocity = movement_vector * 100
	move_and_slide()
