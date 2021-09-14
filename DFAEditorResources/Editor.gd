extends Control
onready var NewSymbol = $AlphabetEdit/NewSymbol
onready var Symbols = $AlphabetEdit/Symbols
onready var States = $StateEdit/States
const StateEditUI : PackedScene = preload("res://DFAEditorResources/StateEditUI.tscn")
const StageUI :PackedScene = preload("res://ExecutionStage/ExecutionStage.tscn")

onready var dfa : DFA = DFA.new([],[],{},"",[])

func _on_AddAlphaButton_pressed():
	if NewSymbol.text in dfa.symbolSet:
		push_error("this symbol is already in the symbolSet")
		return
	if len(NewSymbol.text) != 1:
		push_error("only one-character symbols are supported")
		return
	
	dfa.symbolSet.append(NewSymbol.text)
	var symbolUI = RichTextLabel.new()
	symbolUI.size_flags_horizontal = SIZE_EXPAND_FILL
	symbolUI.size_flags_vertical = SIZE_EXPAND_FILL
	symbolUI.text = NewSymbol.text
	Symbols.add_child(symbolUI)
	var states = States.get_children()
	for state in states:
		state.addTransition(NewSymbol.text, state.getId())
		dfa.transFunc[state.getId()][NewSymbol.text] = state.getId()


func _on_TransitionChanged(id : String, symbol : String, target: String) -> void:
	dfa.transFunc[id][symbol] = target
	print(dfa)

func _on_FinalStateChanged(id, isFinal):
	if id in dfa.endStates and not isFinal:
		dfa.endStates.erase(id)
	
	if not id in dfa.endStates and isFinal:
		dfa.endStates.append(id)
	
	print(dfa)

func _on_AddStateButton_pressed():
	if $StateEdit/NewStateName.text in dfa.stateSet:
		push_error("There is an existing state with this name")
		return
	
	dfa.stateSet.append($StateEdit/NewStateName.text)
	dfa.transFunc[$StateEdit/NewStateName.text] = {}
	$StateEdit/StartState.add_item($StateEdit/NewStateName.text)
	var state = StateEditUI.instance()
	state.setId($StateEdit/NewStateName.text)
	$StateEdit/States.add_child(state)
	state.connect("transition_changed", self, "_on_TransitionChanged")
	state.connect("final_toggled",self,"_on_FinalStateChanged")
	state.connect("starting_selected",self,"onStartStateSelected")
	for sym in dfa.symbolSet:
		dfa.transFunc[state.getId()][sym] = state.getId()
		state.addTransition(sym, state.getId())
	if len(dfa.stateSet) == 1:
		$StateEdit/States.get_child(0).toggleIsStarting(true)

func onStartStateSelected(id)->void:
	dfa.startState = id
	for state in $StateEdit/States.get_children():
		if state.getId() != id:
			print("starting tick removed " + state.getId())
			state.toggleIsStarting(false)
	

func _on_RunButton_pressed():
	StateMetadata.dfa = dfa
	get_tree().change_scene_to(StageUI)
