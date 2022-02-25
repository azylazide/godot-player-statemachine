extends "res://fsm/player/player_state.gd"

#functions and variables for anything while on the ground

func enter(_prev_info:={}) -> void:
	#reset air dash bool when on ground
	player.can_adash = true
	player.can_ajump = true
	player.floor_snap = true

func state_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("jump"):
		state_machine.switch_states("Jump")
	
	if _event.is_action_pressed("dash"):
		if player.dash_cooldown.is_stopped():
			player.dash_cooldown.start()
			state_machine.switch_states("GDash")

func state_physics(_delta: float) -> void:
	.state_physics(_delta)
