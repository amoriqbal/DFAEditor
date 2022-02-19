extends Control
onready var NewSymbol = $AlphabetEdit/NewSymbol
onready var Symbols = $AlphabetEdit/Symbols
onready var States = $StateEdit/States
const StateEditUI : PackedScene = preload("res://DFAEditorResources/StateEditUI.tscn")
var StageUI :PackedScene = load("res://ExecutionStage/ExecutionStage.tscn")

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
	
	NewSymbol.text = ""


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
	var newStateName = $StateEdit/HBoxContainer/NewStateName.text
	$StateEdit/HBoxContainer/NewStateName.text = ""
	if newStateName in dfa.stateSet:
		push_error("There is an existing state with this name")
		return
	
	dfa.stateSet.append(newStateName)
	dfa.transFunc[newStateName] = {}
	#$StateEdit/StartState.add_item($StateEdit/NewStateName.text)
	var state = StateEditUI.instance()
	state.setId(newStateName)
	$StateEdit/States.add_child(state)
	StateMetadata.registerState(newStateName, state)
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
	SceneManager.stageDFA(dfa)

func _on_MenuButton_pressed(id):
	if id == 0:
		$StateEdit/HBoxContainer/MenuButton/OpenFileDialog.popup_centered_ratio()
	else:
		$StateEdit/HBoxContainer/MenuButton/SaveFileDialog.popup_centered_ratio()

func init(_dfa:DFA):
	for i in _dfa.symbolSet:
		$AlphabetEdit/NewSymbol.text = i
		_on_AddAlphaButton_pressed()
	
	for i in _dfa.stateSet:
		$StateEdit/HBoxContainer/NewStateName.text = i
		_on_AddStateButton_pressed()
	
	for id in _dfa.transFunc:
		for sym in _dfa.transFunc[id]:
			_on_TransitionChanged(id, sym, _dfa.transFunc[id][sym])
	
	for i in _dfa.stateSet:
		if i in _dfa.endStates:
			StateMetadata.getStateById(i).toggleIsFinal(true)
			#_on_FinalStateChanged(i, true)
		else:
			StateMetadata.getStateById(i).toggleIsFinal(false)
			#_on_FinalStateChanged(i, false)
	
	StateMetadata.getStateById(_dfa.startState).toggleIsStarting(true)
	#onStartStateSelected(_dfa.startState)


func _ready():
	$StateEdit/HBoxContainer/MenuButton.get_popup().connect("id_pressed",self, "_on_MenuButton_pressed")
	
	if "Editor" in SceneManager.payload:
		init(SceneManager.payload["Editor"])
		SceneManager.payload.erase("Editor")

func _on_OpenFileDialog_file_selected(path):
	var file = File.new()
	file.open(path,File.READ)
	var _dfa = DFA.new()
	_dfa.import_from_file(file)
	SceneManager.editDFA(_dfa)
	file.close()


func _on_SaveFileDialog_file_selected(path):
	var file = File.new()
	file.open(path,File.WRITE)
	dfa.export_to_file(file)
	file.close()
