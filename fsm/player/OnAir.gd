extends "res://fsm/player/player_state.gd"

#functions and variables for anything while on air

func enter(_state_info:={}) -> void:
	pass

func state_physics(_delta: float) -> void:
	.state_physics(_delta)
	
	if player.on_wall:
		var direction = player.get_direction()
		if direction != 0:
			if player.wall_normal != Vector2.ZERO and direction*player.wall_normal.x < 0:
				print("wall clingable")
			elif player.wall_normal.x == 0:
				player.wall_normal.x = -player.get_direction() 
				print("double wall")
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
