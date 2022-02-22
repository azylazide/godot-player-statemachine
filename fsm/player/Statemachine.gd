extends StateMachine
#state machine of the player node

func _unhandled_input(_event: InputEvent) -> void:
	._unhandled_input(_event)
	pass

func _process(_delta: float) -> void:
	owner.get_node("VBoxContainer/Label").text = current_state.name
	owner.get_node("VBoxContainer/Label2").text = "velx: " + str(stepify(owner.velocity.x,0.01)) + " vely: " + str(stepify(owner.velocity.y,0.01))
	._process(_delta)
	pass

func _physics_process(_delta: float) -> void:
	._physics_process(_delta)
	pass

