extends Position2D

const IDLE_DURATION := 1.0

export var move_to := Vector2.UP * 5*64
export var speed := 2.0*64

var follow:= Vector2.ZERO

onready var moving_platform := $plat1
onready var plat_tween:= $Tween

func _ready() -> void:
	_init_tween()
	
func _init_tween() -> void:
	var duration:= move_to.length()/speed
	plat_tween.interpolate_property(self, "follow", Vector2.ZERO, move_to, duration, plat_tween.TRANS_LINEAR, plat_tween.EASE_IN_OUT, IDLE_DURATION)
	plat_tween.interpolate_property(self, "follow", move_to, Vector2.ZERO, duration, plat_tween.TRANS_LINEAR, plat_tween.EASE_IN_OUT, duration + 2*IDLE_DURATION)
	plat_tween.start()

func _physics_process(delta: float) -> void:
	moving_platform.position = moving_platform.position.linear_interpolate(follow, 0.075)
