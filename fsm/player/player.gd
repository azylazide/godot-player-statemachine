extends KinematicBody2D

#player controller script

export(float) var MAX_RUN = 800
export(float) var MAX_FALL = 1000
export(float) var MAX_WALK_TILE = 6.25

var velocity = Vector2.ZERO
var jump_force: float
var min_jump_force: float
var dash_force: float
var direction: float
var face_direction: float

var _tile_units:= 64.0 #px/tile
var _jump_height:= 5.5
var _gap_length:= 12.5
var _jump_time:= 0.8
var _fall_time:= 0.8
var _dash_length:= 5.0
var _dash_time:= 0.2

var jump_grav: float
var fall_grav: float
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
	jump_grav = _jump_gravity()
	fall_grav = _fall_gravity()
	#calculate jump constant
	jump_force = -_jump_vel()
	min_jump_force = -_jump_vel(0.5,_gap_length/2.0)
	#calculate dash constant
	dash_force = _dash_speed()
	
	#initialize values
	on_floor = is_on_floor()
	was_on_floor = is_on_floor()
	face_direction = 1.0
	
	dash_cooldown.wait_time = dash_cooldown_time
	coyote_timer.wait_time = coyote_time
# warning-ignore:return_value_discarded
	coyote_timer.connect("timeout",self,"_reset_coyote_time")
	jump_bufferer.wait_time = jump_buffer
	
	pass

func get_direction() -> float:
	return Input.get_axis("left","right")

func apply_gravity(delta) -> void:
	#skip gravity when coyote time
	if not coyote_timer.is_stopped():
		velocity.y = 0
		return
	
	if velocity.y < 0:
		velocity.y += jump_grav*delta
	else:
		velocity.y += fall_grav*delta
	#terminal velocity
	velocity.y = min(velocity.y,MAX_FALL)

func calculate_velocity() -> void:
	direction = get_direction()
	velocity.x = lerp(velocity.x, MAX_WALK_TILE*_tile_units*direction,0.6)
	
func apply_movement() -> void:
	velocity = move_and_slide(velocity,Vector2.UP)
	
	#save face direction; updates to last direction
	if direction == 0:
		return
	face_direction = -1 if direction < 0 else 1
	pass

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

func _reset_coyote_time() -> void:
	coyote_timer.wait_time = coyote_time

#movement parameter calculations

func _jump_gravity() -> float:
	var output = 2*(_jump_height*_tile_units*pow(MAX_WALK_TILE*_tile_units,2))/(pow(_gap_length*_tile_units/2.0,2))
	return output

func _fall_gravity() -> float:
	var output = 2*(1.5*_jump_height*_tile_units*pow(MAX_WALK_TILE*_tile_units,2))/(pow(0.8*_gap_length*_tile_units/2.0,2))
	return output

func _jump_vel(h: float = _jump_height, x: float = _gap_length) -> float:
	var output = (2*h*_tile_units*MAX_WALK_TILE*_tile_units)/(x*_tile_units/2.0)
	return output

func _dash_speed() -> float:
	return _dash_length*_tile_units/_dash_time
