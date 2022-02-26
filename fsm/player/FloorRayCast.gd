extends Position2D

onready var floor_cast:= $RayCast2D
var collider: Object = null

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	collider = floor_cast.get_collider()
	print(collider)
	pass
