extends "res://fsm/player/OnWall.gd"

func enter(_prev_info:={}) -> void:
#	.enter(_prev_info)
	
	#halt momentum at start of wall slide
	player.velocity.x = 0
	player.velocity.y = 0
	pass

func state_physics(_delta: float) -> void:
	
	#wait a few milliseconds before sticking to wall
	#player.velocity.x = -(player.wall_normal.x/player.wall_normal.x)*sticking_vel
	
	#if player leaves wall by moving away
	var direction = player.get_direction() 
	
	#slowdown custom gravity for sliding
	player.velocity.y += 0.3*player.fall_grav*_delta
	#TO DO: change to custom terminal sliding speed
	player.velocity.y = min(player.velocity.y,player.MAX_FALL_TILE*player._tile_units)
	
	player.prior_grounded()
	player.apply_movement()
	player.after_grounded()
	player.wall_collision()
	
	#if player leaves wall by end of wall
	if not player.on_wall:
		#if wall ends but is on ground
		if player.on_floor:
			state_machine.switch_states("Idle")
		#if wall ends and player falls
		else:
			state_machine.switch_states("Fall")
		pass

func state_input(_event: InputEvent) -> void:
	#if player leaves wall by jumping off
	if _event.is_action_pressed("jump"):
		pass
	#if player dashes off wall
	elif _event.is_action_pressed("dash"):
		pass
