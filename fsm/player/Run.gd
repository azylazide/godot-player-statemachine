extends "res://fsm/player/OnGround.gd"

func enter(_prev_info:={}) -> void:
	.enter(_prev_info)

func exit() -> Dictionary:
	return _state_info

func _ready() -> void:
	pass

func state_physics(_delta: float) -> void:
	.state_physics(_delta)
	
	if abs(player.velocity.x) < 0.1 and player.on_floor:
		state_machine.switch_states("Idle")
	
	if not player.on_floor and player.was_on_floor:
		player.coyote_timer.start()
	
	if not player.on_floor and not player.was_on_floor:
		state_machine.switch_states("Fall")
	pass

func state_input(_event: InputEvent) -> void:
	.state_input(_event)
