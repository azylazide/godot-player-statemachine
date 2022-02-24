extends State


func _ready() -> void:
	pass

func enter(_prev_info:={}):
	yield(get_tree().create_timer(5.0),"timeout")
	owner.queue_free()
	pass

func state_process(_delta: float) -> void:
	$"../../CollisionShape2D".modulate = lerp($"../../CollisionShape2D".modulate,Color(0,0,0,0),0.01)
