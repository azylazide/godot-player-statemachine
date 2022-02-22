extends KinematicBody2D

#player controller script

export(float) var MAX_RUN = 800
export(float) var MAX_WALK = 400
export(float) var MAX_FALL = 1000

var velocity = Vector2.ZERO
var jump_force: float
var dash_force: float
var direction: float
var face_direction: float

var _tile_units:= 64.0
var _jump_height:= 3.5
var _gap_length:= 4.0
var _jump_time:= 0.8
var _dash_length:= 5.0
var _dash_time:= 0.2

var grav: float
var on_floor: bool
var was_on_floor: bool

onready var dash_cooldown:= $DashCooldown
var dash_cooldown_time := 0.3
var can_adash:= true

onready var coyote_timer:= $CoyoteTime 
var coyote_time:= 0.1

var can_ajump:= true

onready var jump_bufferer:= $JumpBufferTime
var jump_buffer:= 0.1

func _ready() -> void:
	#calculate gravity constant
	grav = _gravity()
	#calculate jump constant
	jump_force = -grav*_jump_time
	#calculate dash constant
	dash_force = _dash_speed()
	
	#initialize values
	on_floor = is_on_floor()
	was_on_floor = is_on_floor()
	face_direction = 1.0
	
	dash_cooldown.wait_time = dash_cooldown_time
	coyote_timer.wait_time = coyote_time
	jump_bufferer.wait_time = jump_buffer
	
	pass

func get_direction() -> float:
	return Input.get_axis("left","right")

func apply_gravity(delta) -> void:
	#skip gravity when coyote time
	if not coyote_timer.is_stopped():
		velocity.y = 0
		return
	
	velocity.y += grav*delta
	#terminal velocity
	velocity.y = min(velocity.y,MAX_FALL)

func calculate_velocity() -> void:
	direction = get_direction()
	velocity.x = lerp(velocity.x, MAX_WALK*direction,0.6)
	
func apply_movement() -> void:
	velocity = move_and_slide(velocity,Vector2.UP)
	
	#save face direction; updates to last direction
	if direction == 0:
		return
	face_direction = direction
	pass

func _gravity() -> float:
	var output = 2*(_jump_height*_tile_units)/(_jump_time*_jump_time)
	return output

func _dash_speed() -> float:
	return _dash_length*_tile_units/_dash_time

#checks ground prior to movement
func prior_grounded() -> void:
	was_on_floor = floor_check()
	pass

#check ground after movement
func after_grounded() -> void:
	on_floor = floor_check()
	pass

func floor_check() -> bool:
	return is_on_floor() or not coyote_timer.is_stopped()
