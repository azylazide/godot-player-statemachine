extends "res://fsm/player/player_state.gd"

#functions and variables for anything while on air

func _ready() -> void:
	pass

func state_physics(_delta: float) -> void:
	.state_physics(_delta)

func state_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("dash"):
		if player.dash_cooldown.is_stopped() and player.can_adash:
			player.dash_cooldown.start()
			player.can_adash = false
			state_machine.switch_states("ADash")
