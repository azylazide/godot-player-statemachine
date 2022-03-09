extends "res://fsm/player/OnAir.gd"

#dash duration
var timer: Timer

func _ready() -> void:
	timer = $Timer
	timer.wait_time = player.DASH_TIME

func enter(_prev_info:={}) -> void:
	.enter(_prev_info)
	#apply dash and cancel gravity
	player.velocity.x = player.dash_force*player.face_direction
	player.velocity.y = 0.0
	timer.start()
	pass

func state_physics(_delta: float) -> void:
	player.apply_movement()
	player.after_grounded()
	player.wall_collision()
	
	if timer.is_stopped():
		if player.on_floor:
			if player.get_direction() != 0:
				state_machine.switch_states("Run")
			else:
				state_machine.switch_states("Idle")
		else:
			state_machine.switch_states("Fall")
	
	pass
