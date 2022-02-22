extends "res://fsm/player/OnGround.gd"

func enter(_prev_info:={}) -> void:
	.enter(_prev_info)
	player.velocity.x = 0

func exit() -> Dictionary:
	return _state_info

func _ready() -> void:
	print(player)
	pass
	
func state_input(_event: InputEvent) -> void:
	.state_input(_event)
	pass

func state_physics(_delta: float) -> void:
	.state_physics(_delta)
	
	if player.velocity.x != 0:
		state_machine.switch_states("Run")
	
	#start coyote time
	if not player.on_floor and player.was_on_floor:
		player.coyote_timer.start()
	
	#transition when coyote time is not active (both checks satisfy)
	if not player.on_floor and not player.was_on_floor:
		state_machine.switch_states("Fall")
	
	pass
