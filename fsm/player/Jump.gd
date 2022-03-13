extends "res://fsm/player/OnAir.gd"

onready var walljump_holder:= $WallJumpHold

func _ready() -> void:
	#should be WALL_KICK_TIME but fix this since this _ready fires before player _ready
	walljump_holder.wait_time = 2

func enter(_prev_info:={}) -> void:
	.enter(_prev_info)
	player.floor_snap = false
	player.coyote_timer.stop()
	
	if _prev_state.name == "Fall":
		player.velocity.y = player.jump_force*0.8
	elif _prev_state.name == "GDash":
		player.velocity.y = player.jump_force*1.2
	elif _prev_state.name == "WallCling":
		walljump_holder.start()
		player.velocity.x = player.face_direction*player.wall_kick
		player.velocity.y = player.jump_force
	else:
		player.velocity.y = player.jump_force

	#apply horizontal velocity if coming from wall cling or a wall jump

func state_physics(_delta: float) -> void:
	player.apply_gravity(_delta)
	if _prev_state.name == "WallCling" and not walljump_holder.is_stopped():
		pass
	else:
		player.calculate_velocity()
	player.prior_grounded()
	player.apply_movement()
	player.after_grounded()
	player.wall_collision()
	
	#transition after peak of jump
	if player.velocity.y > 0:
		state_machine.switch_states("Fall")
	pass

func state_input(_event: InputEvent) -> void:
	if _event.is_action_released("jump") and player.velocity.y < player.min_jump_force:
		player.velocity.y = player.min_jump_force
		state_machine.switch_states("Fall")
	
	.state_input(_event)
