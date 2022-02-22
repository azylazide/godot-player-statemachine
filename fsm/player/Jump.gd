extends "res://fsm/player/OnAir.gd"

func enter(_prev_info:={}) -> void:
	player.coyote_timer.stop()
	player.velocity.y = player.jump_force
	pass

func exit() -> Dictionary:
	return _state_info

func state_physics(_delta: float) -> void:
	.state_physics(_delta)
	
	if player.velocity.y > 0:
		state_machine.switch_states("Fall")
	pass
