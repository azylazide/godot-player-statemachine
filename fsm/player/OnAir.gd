extends "res://fsm/player/player_state.gd"

#functions and variables for anything while on air

func enter(_state_info:={}) -> void:
	pass

func state_physics(_delta: float) -> void:
	.state_physics(_delta)
	
	if player.on_wall:
		if player.get_direction().normalized() == -player.wall_normal.normalized():
			pass

func state_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("dash"):
		if player.dash_cooldown.is_stopped() and player.can_adash:
			player.dash_cooldown.start()
			player.can_adash = false
			state_machine.switch_states("ADash")

	if _event.is_action_pressed("jump"):
		if player.velocity.y > 0:
			player.jump_bufferer.start()
		
		pass
