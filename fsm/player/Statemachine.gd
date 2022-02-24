extends StateMachine
#state machine of the player node

func _unhandled_input(_event: InputEvent) -> void:
	._unhandled_input(_event)
	pass

func _process(_delta: float) -> void:
	owner.get_node("VBoxContainer/Label").text = current_state.name
	owner.get_node("VBoxContainer/Label2").text = "velx: " + str(stepify(owner.velocity.x,0.01)) + " vely: " + str(stepify(owner.velocity.y,0.01))
	owner.get_node("VBoxContainer/Label3").text = "dir: " + str(owner.get_direction())
	owner.get_node("VBoxContainer/Label4").text = "coyote time: " + ("off" if owner.coyote_timer.is_stopped() else "on")
	owner.get_node("VBoxContainer/Label5").text = "was on floor: " + ("true" if owner.was_on_floor else "false") + "; is on floor: " + ("true" if owner.on_floor else "false")
	owner.get_node("VBoxContainer/Label6").text = "on wall: " + ("true" if owner.on_wall else "false")
	owner.get_node("VBoxContainer/Label7").text = "can_ajump: " + ("true" if owner.can_ajump else "false") + "; can_adash: " + ("true" if owner.can_adash else "false")
	._process(_delta)
	pass

func _physics_process(_delta: float) -> void:
	._physics_process(_delta)
	pass

