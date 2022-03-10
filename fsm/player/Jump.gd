extends "res://fsm/player/OnAir.gd"

func enter(_prev_info:={}) -> void:
	.enter(_prev_info)
	player.floor_snap = false
	player.coyote_timer.stop()
	
	if _prev_state.name == "Fall":
		player.velocity.y = player.jump_force*0.8
	elif _prev_state.name == "GDash":
		player.velocity.y = player.jump_force*1.2
	else:
		player.velocity.y = player.jump_force

	#apply horizontal velocity if coming from wall cling or a wall jump

func state_physics(_delta: float) -> void:
	.state_physics(_delta)
	
	#transition after peak of jump
	if player.velocity.y > 0:
		state_machine.switch_states("Fall")
	pass

func state_input(_event: InputEvent) -> void:
	if _event.is_action_released("jump") and player.velocity.y < player.min_jump_force:
		player.velocity.y = player.min_jump_force
		state_machine.switch_states("Fall")
	
	.state_input(_event)
