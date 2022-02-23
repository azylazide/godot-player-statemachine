extends "res://fsm/player/OnAir.gd"

func enter(_prev_info:={}) -> void:
	player.coyote_timer.stop()
	player.velocity.y = player.jump_force
	pass

func exit() -> Dictionary:
	return _state_info

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
