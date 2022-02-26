extends Position2D

const IDLE_DURATION := 1.0

export var MOVE_TO := Vector2.UP*10
export var SPEED := 3.0

var tile_units:= 64

var follow:= Vector2.ZERO
var move_to: Vector2
var speed: float

onready var moving_platform := $plat1
onready var plat_tween:= $Tween

func _ready() -> void:
	move_to = MOVE_TO*tile_units
	speed = SPEED*tile_units
	_init_tween()
	
func _init_tween() -> void:
	var duration:= move_to.length()/speed
	plat_tween.interpolate_property(self, "follow", Vector2.ZERO, move_to, duration, plat_tween.TRANS_LINEAR, plat_tween.EASE_IN_OUT, IDLE_DURATION)
	plat_tween.interpolate_property(self, "follow", move_to, Vector2.ZERO, duration, plat_tween.TRANS_LINEAR, plat_tween.EASE_IN_OUT, duration + 2*IDLE_DURATION)
	plat_tween.start()

func _physics_process(delta: float) -> void:
	moving_platform.position = moving_platform.position.linear_interpolate(follow, 0.075)
