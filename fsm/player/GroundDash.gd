extends "res://fsm/player/OnGround.gd"

#dash duration
var timer: Timer

func _ready() -> void:
	timer = $Timer
	timer.wait_time = player.DASH_TIME

func enter(_prev_info:={}) -> void:
	.enter(_prev_info)
	#apply dash
	player.velocity.x = player.dash_force*player.face_direction
	timer.start()
	pass

func exit() -> Dictionary:
	return _state_info

func state_physics(_delta: float) -> void:
	player.prior_grounded()
	#keep player on floor when on floor
	if player.on_floor and player.was_on_floor:
		player.apply_gravity(_delta)
	#disable gravity when not on floor; NOTE: will not be in line with same y level
	else:
		player.velocity.y = 0.0
	player.apply_movement()
	player.after_grounded()
	
	if not player.on_floor and player.was_on_floor:
		player.coyote_timer.wait_time = 0.08
		player.coyote_timer.start()
	
	if timer.is_stopped():
		if player.on_floor:
			if player.get_direction() != 0:
				state_machine.switch_states("Run")
			else:
				state_machine.switch_states("Idle")
		elif not player.on_floor and not player.was_on_floor:
			state_machine.switch_states("Fall")
	
	pass

func state_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("jump") and not player.coyote_timer.is_stopped():
		state_machine.switch_states("Jump")
	
	if _event.is_action_pressed("dash"):
		if player.dash_cooldown.is_stopped():
			player.dash_cooldown.start()
			state_machine.switch_states("GDash")
