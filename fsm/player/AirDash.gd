extends "res://fsm/player/OnAir.gd"


var timer: Timer

func _ready() -> void:
	timer = $Timer
	timer.wait_time = player._dash_time

func enter(_prev_info:={}) -> void:
	player.velocity.x = player.dash_force*player.face_direction
	player.velocity.y = 0.0
	timer.start()
	pass

func exit() -> Dictionary:
	return _state_info

func state_physics(_delta: float) -> void:
	player.apply_movement()
	player.after_grounded()
	
	if timer.is_stopped():
		if player.on_floor:
			if player.get_direction() != 0:
				state_machine.switch_states("Run")
			else:
				state_machine.switch_states("Idle")
		else:
			state_machine.switch_states("Fall")
	
	pass
