extends Node

class_name State
#base class for states for StateMachine

signal change_state

var state_machine: Node
var _state_info:={}
var _prev_state: Node

func enter(_prev_info:={}) -> void:
	pass

func exit() -> Dictionary:
	_state_info.clear()
	_prev_state = null
	return _state_info

func state_physics(_delta: float) -> void:
	pass

func state_input(_event: InputEvent) -> void:
	pass

func state_process(_delta: float) -> void:
	pass
