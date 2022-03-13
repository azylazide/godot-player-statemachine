extends KinematicBody2D

#player controller script

export(float) var MAX_FALL_TILE = 15.0
export(float) var MAX_WALK_TILE = 6.25
export(float) var COYOTE_TIME = 0.1
export(float) var JUMP_HEIGHT = 5.5
export(float) var MIN_JUMP_HEIGHT = 0.5
export(float) var JUMP_BUFFER_TIME = 0.1
export(float) var DASH_LENGTH = 5.0
export(float) var DASH_TIME = 0.2
export(float) var DASH_COOLDOWN_TIME = 0.3
export(float) var GAP_LENGTH = 12.5

var velocity:= Vector2.ZERO
var jump_force: float
var min_jump_force: float
var dash_force: float
var direction: float
var face_direction: float

var _tile_units:= 64.0 #px/tile

var jump_grav: float
var fall_grav: float
var on_floor: bool
var was_on_floor: bool
var on_wall: bool
var floor_snap: bool
var wall_normal:= Vector2.ZERO

onready var dash_cooldown:= $DashCooldown
var can_adash:= true

onready var coyote_timer:= $CoyoteTime 
var can_ajump:= true

onready var jump_bufferer:= $JumpBufferTime
var can_wcling:= false

onready var floor_cast:= $FloorRayCast

onready var left_raycast:= $WallRayCast/LeftRay
onready var right_raycast:= $WallRayCast/RightRay

const SLOPE_STOP_THRESHOLD:= 100.0

func _ready() -> void:
	#calculate gravity constant
	jump_grav = _gravity(JUMP_HEIGHT,MAX_WALK_TILE,GAP_LENGTH)
	fall_grav = _gravity(1.5*JUMP_HEIGHT,MAX_WALK_TILE,0.8*GAP_LENGTH)
	#calculate jump constant
	jump_force = -_jump_vel(JUMP_HEIGHT,GAP_LENGTH)
	min_jump_force = -_jump_vel(MIN_JUMP_HEIGHT,GAP_LENGTH/2.0)
	#calculate dash constant
	dash_force = _dash_speed()
	
	#initialize values
	on_floor = is_on_floor()
	was_on_floor = is_on_floor()
	on_wall = false
	face_direction = 1.0
	floor_snap = true
	
	dash_cooldown.wait_time = DASH_COOLDOWN_TIME
	coyote_timer.wait_time = COYOTE_TIME
# warning-ignore:return_value_discarded
	coyote_timer.connect("timeout",self,"_reset_coyote_time")
	jump_bufferer.wait_time = JUMP_BUFFER_TIME
	
	pass

func get_direction() -> float:
	return Input.get_axis("left","right")

func apply_gravity(delta) -> void:
	#skip gravity when coyote time
	if not coyote_timer.is_stopped():
		velocity.y = 0
		return
	
	#apply normal gravity for jump
	if velocity.y < 0:
		velocity.y += jump_grav*delta
	#apply larger gravity for fall
	else:
		velocity.y += fall_grav*delta
		
	#terminal velocity
	velocity.y = min(velocity.y,MAX_FALL_TILE*_tile_units)

func calculate_velocity() -> void:
	direction = get_direction()
	velocity.x = lerp(velocity.x, MAX_WALK_TILE*_tile_units*direction,0.6)
	
func apply_movement() -> void:

	velocity = move_and_slide_with_snap(velocity,is_floor_snap(),Vector2.UP)
	
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

func wall_collision() -> void:
	on_wall = wall_check()

func floor_check() -> bool:
	var output: bool
	if floor_cast.collider is TileMap:
		if floor_cast.collider.collision_layer == 1:
			output = true
		else:
			output = false
	elif floor_cast.collider is PhysicsBody2D:
		if floor_cast.collider.layers == 1:
			output = true
		else:
			output = false
	return is_on_floor() or not coyote_timer.is_stopped()

func wall_check() -> bool:
	
	#TO DO: check if wall is valid for wall clinging
	var left: bool = left_raycast.is_colliding()
	var right: bool = right_raycast.is_colliding()
	
	#check if player is close to two walls
	if left and right:
		wall_normal = Vector2.ZERO
		return true
	#check left
	elif left:
		wall_normal = left_raycast.get_collision_normal()
		#check for valid wall angle
		if atan2(wall_normal.y,wall_normal.x) == 0:
			return true
		return false
	#check right
	elif right:
		wall_normal = right_raycast.get_collision_normal()
		#check for valid wall angle
		if atan2(wall_normal.y,wall_normal.x) == 0:
			return true
		return false
	#no wall
	else:
		return false

func is_floor_snap() -> Vector2:
	#enable floor snap vector when snap to floor
	var output:= Vector2.DOWN*43
	if floor_snap:
		return output
	else:
		return Vector2.ZERO

func _reset_coyote_time() -> void:
	coyote_timer.wait_time = COYOTE_TIME

#movement parameter calculations

func _gravity(h: float, vx: float, x: float) -> float:
	var output = 2*(h*_tile_units*pow(vx*_tile_units,2))/(pow(x*_tile_units/2.0,2))
	return output

func _jump_vel(h: float, x: float) -> float:
	var output = (2*h*_tile_units*MAX_WALK_TILE*_tile_units)/(x*_tile_units/2.0)
	return output

func _dash_speed() -> float:
	return DASH_LENGTH*_tile_units/DASH_TIME

#debug
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_esc"):
		$MainSM.switch_states("Death")
