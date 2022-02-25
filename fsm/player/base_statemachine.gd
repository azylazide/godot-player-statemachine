extends Node
class_name StateMachine
#Base state machine class
#Statemachine node must have state nodes as children and states added to a group


#group of the state nodes 
export(String) var state_group = null
#current state
var current_state: State
#initial state
export(NodePath) var init_state
#list of states as nodes
var _state_list := []
#dict of states as name node pair
var state_dict :={}


func _ready():
	_get_states()
	_connect_states()
	_initial_state(init_state)
	
	pass

#relegate inputs to state
func _unhandled_input(_event: InputEvent) -> void:
	current_state.state_input(_event)
	pass

func _process(_delta: float) -> void:
	current_state.state_process(_delta)
	pass

#relegate physics to state
func _physics_process(_delta: float) -> void:
	current_state.state_physics(_delta)
	pass

#handle switching of states
func switch_states(_new_state: String) -> void:
	_debug_print_state(current_state,_new_state)
	
	#double-check if it is in dict
	if not state_dict.has(_new_state):
		return
	
	#get info from old state, run its exit function
	var state_info = current_state.exit()
	#get reference to new state
	current_state = state_dict[_new_state]
	#enter new state passing old info
	current_state.enter(state_info)
	pass

#get states from specified group and add to dict
func _get_states() -> void:
	_state_list = get_tree().get_nodes_in_group(state_group)
	for s in _state_list:
		state_dict[s.name] = s

#pass self reference to the state nodes
func _connect_states() -> void:
	for s in _state_list:
		s.state_machine = self
		pass

#set initial state
func _initial_state(_s: NodePath) -> void:
	current_state = get_node(_s)
	current_state.enter()
	pass

#var leaves = []
#find_leaves(state_machine_node, leaves)
#func find_leaves(parent:Node, results:Array):
#    if parent.get_child_count() == 0:
#        results.append(parent)
#    for child in parent.get_children():
#        find_leaves(child, results)

func _debug_print_state(initial: Node,final: String) -> void:
	print("Switching from ",initial.name," to ",final)
