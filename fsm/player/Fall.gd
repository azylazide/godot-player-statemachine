extends "res://fsm/player/OnAir.gd"


func _ready() -> void:
	pass

func exit() -> Dictionary:
	return _state_info

func state_physics(_delta: float) -> void:
	.state_physics(_delta)
	
	if player.on_floor:
		state_machine.switch_states("Idle")

func state_input(_event: InputEvent) -> void:
	.state_input(_event)
	
	if _event.is_action_pressed("jump") and player.can_ajump:
		player.can_ajump = false
		player.jump_bufferer.stop()
		state_machine.switch_states("Jump")
