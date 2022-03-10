extends "res://fsm/player/OnAir.gd"


func state_physics(_delta: float) -> void:
	.state_physics(_delta)
	
	#only wall slide when falling
	if player.on_wall:
		var direction = player.get_direction()
		if direction != 0:
			if player.wall_normal != Vector2.ZERO and direction*player.wall_normal.x < 0:
				print("wall clingable")
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
			
		if player.can_ajump:
			player.can_ajump = false
			player.jump_bufferer.stop()
			state_machine.switch_states("Jump")
