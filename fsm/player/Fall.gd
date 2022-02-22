extends "res://fsm/player/OnAir.gd"


func _ready() -> void:
	pass

func enter(_state_info:={}) -> void:
	pass

func exit() -> Dictionary:
	return _state_info

func state_physics(_delta: float) -> void:
	.state_physics(_delta)
	
	if player.on_floor:
		state_machine.switch_states("Idle")
