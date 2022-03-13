extends "res://fsm/player/OnAir.gd"


func state_physics(_delta: float) -> void:
	.state_physics(_delta)
	
	#only wall slide only when falling
	if player.on_wall:
		var direction = player.get_direction()
		if direction != 0:
			if player.wall_normal != Vector2.ZERO and direction*player.wall_normal.x < 0:
#				print("wall clingable")
				state_machine.switch_states("WallCling")
			elif player.wall_normal.x == 0.0:
				player.wall_normal.x = -direction
				print("double wall")
	
	if player.on_floor:
		state_machine.switch_states("Idle")

func state_input(_event: InputEvent) -> void:
	.state_input(_event)
	
	if _event.is_action_pressed("jump"):
		if player.velocity.y > 0:
			player.jump_bufferer.start()
		
		#transition to wall jump when near wall while falling even if not in slide state
		if player.on_wall:
			pass
		
		#wall jump has priority over double jump	
		elif not player.on_wall and player.can_ajump:
			player.can_ajump = false
			player.jump_bufferer.stop()
			state_machine.switch_states("Jump")
