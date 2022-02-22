extends State

#General movement state with its functions and variables
#All movement states inherits from this script

var player: Node

func _ready() -> void:
	#set player as owner for name convenience
	player = owner
	pass

func state_physics(_delta: float) -> void:
	player.apply_gravity(_delta)
	player.calculate_velocity()
	player.apply_movement()
	player.after_grounded()
	pass

#

