extends "res://fsm/player/player_state.gd"

#functions and variables for anything while on the ground

func enter(_prev_info:={}) -> void:
	player.can_adash = true

func state_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("jump"):
		state_machine.switch_states("Jump")
	
	if _event.is_action_pressed("dash"):
		if player.dash_cooldown.is_stopped():
			player.dash_cooldown.start()
			state_machine.switch_states("GDash")

func state_physics(_delta: float) -> void:
	player.apply_gravity(_delta)
	player.calculate_velocity()
	player.prior_grounded()
	player.apply_movement()
	player.after_grounded()
